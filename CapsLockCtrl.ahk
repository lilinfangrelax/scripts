; CapsLock: 短按 = Esc, 长按 = Ctrl
; Alt+鼠标滚轮: 切换虚拟桌面 (Ctrl+Win+左右方向键)
; Ctrl+Alt+M: 切换自动移动鼠标防锁屏
#Requires AutoHotkey >=2.0
;@Ahk2Exe-SetName          CapsLockCtrl
;@Ahk2Exe-SetDescription   CapsLock→Esc/Ctrl / Alt+Wheel→虚拟桌面 / 防锁屏鼠标微移
;@Ahk2Exe-SetVersion       1.0.0

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

!WheelUp::Send("^#{Left}")
!WheelDown::Send("^#{Right}")

; ==== 防锁屏：定时微移鼠标 ====
antiIdleActive := false

^!m::  ; Ctrl+Alt+M 切换
{
    global antiIdleActive
    antiIdleActive := !antiIdleActive
    if (antiIdleActive)
    {
        SetTimer(MoveMouse, 30000)  ; 每 30 秒执行一次
        ToolTip("防锁屏已开启")
    }
    else
    {
        SetTimer(MoveMouse, 0)  ; 关闭定时器
        ToolTip("防锁屏已关闭")
    }
    SetTimer(() => ToolTip(), -1500)  ; 1.5 秒后清除提示
}

MoveMouse()
{
    MouseMove(0, 1, 0, "R")   ; 下移 1 像素
    Sleep(50)
    MouseMove(0, -1, 0, "R")  ; 移回原位
}
