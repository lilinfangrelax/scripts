; CapsLock: 短按 = Esc, 长按 = Ctrl
; Alt+鼠标滚轮: 切换虚拟桌面 (Ctrl+Win+左右方向键)
#Requires AutoHotkey >=2.0

CapsLock::
{
    ; 等待 200ms 判断是按还是长按
    if (KeyWait("CapsLock", "T0.2"))  ; 200ms 内松手 → 短按
        Send("{Esc}")
    else  ; 超过 200ms → 长按，按住 Ctrl 直到松手
    {
        Send("{Ctrl Down}")
        KeyWait("CapsLock")
        Send("{Ctrl Up}")
    }
}

!WheelUp::Send("^#{Right}")
!WheelDown::Send("^#{Left}")
