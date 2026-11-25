<#
.SYNOPSIS
    ROCCAT Torch Microphone Unlocker (Bilingual: PT-BR / EN).
.DESCRIPTION
    Resolves the mute lock bug (static red LED / DISABLED status on mixer base)
    for the ROCCAT Torch USB microphone via Windows CoreAudio API (IAudioEndpointVolume).
    Automatically detects the system language (Portuguese or English).
.PARAMETER NonInteractive
    Skips waiting for a key press at the end of execution.
.PARAMETER Lang
    Optional language override ('pt' or 'en'). Auto-detects if omitted.
#>

param(
    [switch]$NonInteractive,
    [ValidateSet('auto', 'pt', 'en')]
    [string]$Lang = 'auto'
)

# ============================================================
#  AUTO-DETECT SYSTEM LANGUAGE (PT-BR / EN)
# ============================================================
$culture = [System.Globalization.CultureInfo]::CurrentUICulture
$cultureName = $culture.Name

if ($Lang -eq 'pt') {
    $isPT = $true
} elseif ($Lang -eq 'en') {
    $isPT = $false
} else {
    $isPT = ($culture.TwoLetterISOLanguageName -eq 'pt')
}

$L = if ($isPT) {
    @{
        Header        = "============================================================"
        Title         = "        DESTRAVADOR DO MICROFONE ROCCAT TORCH (v1.0.0)"
        DetectedLang  = "Idioma detectado: Portugues ($cultureName)"
        Searching     = "Procurando microfone ROCCAT Torch conectado..."
        DeviceFound   = "Dispositivo encontrado: "
        PreviousMuted = "Estado anterior: MUDO / TRAVADO EM VERMELHO"
        PreviousOk    = "Estado anterior: JA ESTAVA DESMUTADO (Normal)"
        Success       = "SUCESSO: Microfone DESTRAVADO e reativado com sucesso!"
        Warning       = "AVISO: Nao foi possivel alterar o estado de mudo."
        ActivateErr   = "Erro ao acessar o endpoint de audio (hr: 0x"
        NotFound      = "Nenhum microfone 'Torch' ativo encontrado conectado no computador."
        Footer        = "Concluido! Se o microfone estava vermelho, ele voltara ao RGB normal."
        PressKey      = "Pressione qualquer tecla para sair..."
    }
} else {
    @{
        Header        = "============================================================"
        Title         = "           ROCCAT TORCH MICROPHONE UNLOCKER (v1.0.0)"
        DetectedLang  = "Detected system language: English ($cultureName)"
        Searching     = "Searching for connected ROCCAT Torch microphone..."
        DeviceFound   = "Device found: "
        PreviousMuted = "Previous state: MUTED / STUCK IN RED"
        PreviousOk    = "Previous state: ALREADY UNMUTED (Normal)"
        Success       = "SUCCESS: Microphone UNLOCKED and enabled successfully!"
        Warning       = "WARNING: Unable to change mute state."
        ActivateErr   = "Error accessing audio endpoint (hr: 0x"
        NotFound      = "No active 'Torch' microphone was found connected to this computer."
        Footer        = "Completed! If the mic was glowing red, it will now return to normal RGB."
        PressKey      = "Press any key to exit..."
    }
}

# ============================================================
#  WINDOWS CORE AUDIO COM INTERFACES
# ============================================================
$code = @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IMMDevice {
    int Activate(ref Guid id, int clsCtx, IntPtr activationParams, [MarshalAs(UnmanagedType.IUnknown)] out object interfacePointer);
    int OpenPropertyStore(int stgmAccess, out IPropertyStore properties);
    int GetId([MarshalAs(UnmanagedType.LPWStr)] out string id);
    int GetState(out int state);
}

[Guid("886d8eeb-8cf2-4446-8d02-cdba1dbdcf99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IPropertyStore {
    int GetCount(out uint count);
    int GetAt(uint iProp, out PROPERTYKEY pkey);
    int GetValue(ref PROPERTYKEY key, out PROPVARIANT pv);
    int SetValue(ref PROPERTYKEY key, ref PROPVARIANT pv);
    int Commit();
}

[StructLayout(LayoutKind.Sequential, Pack = 4)]
public struct PROPERTYKEY {
    public Guid fmtid;
    public uint pid;
}

[StructLayout(LayoutKind.Explicit)]
public struct PROPVARIANT {
    [FieldOffset(0)] public ushort vt;
    [FieldOffset(8)] public IntPtr pwszVal;
}

[Guid("0BD7A1BE-7A1A-44DB-8397-CC5392387B5E"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IMMDeviceCollection {
    int GetCount(out uint count);
    int Item(uint id, out IMMDevice device);
}

[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IMMDeviceEnumerator {
    int EnumAudioEndpoints(int dataFlow, int stateMask, out IMMDeviceCollection devices);
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
    int GetDevice(string pwstrId, out IMMDevice endpoint);
}

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
public interface IAudioEndpointVolume {
    int RegisterControlChangeNotify(IntPtr notify);
    int UnregisterControlChangeNotify(IntPtr notify);
    int GetChannelCount(out uint channelCount);
    int SetMasterVolumeLevel(float levelDB, ref Guid eventContext);
    int SetMasterVolumeLevelScalar(float level, ref Guid eventContext);
    int GetMasterVolumeLevel(out float levelDB);
    int GetMasterVolumeLevelScalar(out float level);
    int SetChannelVolumeLevel(uint channel, float levelDB, ref Guid eventContext);
    int SetChannelVolumeLevelScalar(uint channel, float level, ref Guid eventContext);
    int GetChannelVolumeLevel(uint channel, out float levelDB);
    int GetChannelVolumeLevelScalar(uint channel, out float level);
    int SetMute([MarshalAs(UnmanagedType.Bool)] bool mute, ref Guid eventContext);
    int GetMute([MarshalAs(UnmanagedType.Bool)] out bool mute);
    int GetVolumeStepInfo(out uint step, out uint stepCount);
    int VolumeStepUp(ref Guid eventContext);
    int VolumeStepDown(ref Guid eventContext);
    int QueryHardwareSupport(out uint hardwareSupportMask);
    int GetVolumeRange(out float volumeMin, out float volumeMax, out float volumeStep);
}

[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
public class MMDeviceEnumeratorComObject { }

public class TorchResult {
    public string Name;
    public string Id;
    public bool WasMuted;
    public bool IsMutedNow;
    public int ActivateHr;
    public bool Success;
}

public class TorchController {
    public static List<TorchResult> UnlockAll() {
        var results = new List<TorchResult>();
        var enumerator = (IMMDeviceEnumerator)(new MMDeviceEnumeratorComObject());
        IMMDeviceCollection coll;
        // 1 = Capture (Microphones), 1 = DEVICE_STATE_ACTIVE
        enumerator.EnumAudioEndpoints(1, 1, out coll);
        uint count;
        coll.GetCount(out count);

        PROPERTYKEY PKEY_Device_FriendlyName = new PROPERTYKEY {
            fmtid = new Guid("a45c254e-df1c-4efd-8020-67d146a850e0"),
            pid = 14
        };

        for (uint i = 0; i < count; i++) {
            IMMDevice dev;
            coll.Item(i, out dev);
            string name = "";
            try {
                IPropertyStore store;
                dev.OpenPropertyStore(0, out store);
                PROPVARIANT pv;
                store.GetValue(ref PKEY_Device_FriendlyName, out pv);
                name = Marshal.PtrToStringUni(pv.pwszVal) ?? "";
            } catch { }

            if (name.IndexOf("Torch", StringComparison.OrdinalIgnoreCase) >= 0) {
                var res = new TorchResult { Name = name };
                string devId;
                dev.GetId(out devId);
                res.Id = devId;

                Guid IID_IAudioEndpointVolume = typeof(IAudioEndpointVolume).GUID;
                object epVolObj;
                int hr = dev.Activate(ref IID_IAudioEndpointVolume, 23, IntPtr.Zero, out epVolObj);
                res.ActivateHr = hr;

                if (hr == 0 && epVolObj != null) {
                    var epVol = (IAudioEndpointVolume)epVolObj;
                    bool curMute;
                    epVol.GetMute(out curMute);
                    res.WasMuted = curMute;

                    Guid ctx = Guid.Empty;
                    epVol.SetMute(false, ref ctx);

                    bool newMute;
                    epVol.GetMute(out newMute);
                    res.IsMutedNow = newMute;
                    res.Success = (!newMute);
                }
                results.Add(res);
            }
        }
        return results;
    }
}
'@

if (-not ([System.Management.Automation.PSTypeName]'TorchController').Type) {
    Add-Type -TypeDefinition $code
}

# ============================================================
#  EXECUTION & OUTPUT
# ============================================================
Write-Host ""
Write-Host $L.Header -ForegroundColor Cyan
Write-Host $L.Title -ForegroundColor Cyan
Write-Host $L.Header -ForegroundColor Cyan
Write-Host ""
Write-Host $L.DetectedLang -ForegroundColor DarkGray
Write-Host $L.Searching -ForegroundColor Yellow
Write-Host ""

$results = [TorchController]::UnlockAll()

if ($results.Count -eq 0) {
    Write-Host $L.NotFound -ForegroundColor Red
} else {
    foreach ($r in $results) {
        Write-Host ">> $($L.DeviceFound)$($r.Name)" -ForegroundColor White
        if ($r.ActivateHr -ne 0) {
            Write-Host "   $($L.ActivateErr)$($r.ActivateHr.ToString('X')))" -ForegroundColor Red
        } else {
            if ($r.WasMuted) {
                Write-Host "   $($L.PreviousMuted)" -ForegroundColor Red
            } else {
                Write-Host "   $($L.PreviousOk)" -ForegroundColor Gray
            }

            if ($r.Success) {
                Write-Host "   $($L.Success)" -ForegroundColor Green
            } else {
                Write-Host "   $($L.Warning)" -ForegroundColor Red
            }
        }
        Write-Host ""
    }
    Write-Host $L.Header -ForegroundColor Cyan
    Write-Host $L.Footer -ForegroundColor Cyan
    Write-Host $L.Header -ForegroundColor Cyan
}

Write-Host ""
if (-not $NonInteractive -and -not [Console]::IsInputRedirected) {
    Write-Host $L.PressKey -ForegroundColor DarkYellow
    try {
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } catch {
        Read-Host
    }
}
