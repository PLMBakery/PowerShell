Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseJiggler
{
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, int dx, int dy, uint cButtons, uint dwExtraInfo);

    public const uint MOUSEEVENTF_MOVE = 0x0001;

    public static void JiggleMouse()
    {
        mouse_event(MOUSEEVENTF_MOVE, 1, 1, 0, 0);
    }
}
"@

while ($true)
{
    [MouseJiggler]::JiggleMouse()
    Start-Sleep -Seconds 60
}
