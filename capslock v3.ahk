#Requires AutoHotkey v2.0

; 이동 거리 설정
global initial_move := 5    ; 초기 이동 거리
global max_move := 32         ; 최대 이동 거리
global accel_rate := 1.05     ; 가속도 비율
global decel_rate := 0.95     ; 감속도 비율
global diagonal_factor := 0.7 ; 대각선 이동 시 사용할 계수
global sleep_duration := 8    ; Sleep 시간 (ms)

; 스크롤 설정
global initial_scroll := 1     ; 초기 스크롤 양
global max_scroll := 5        ; 최대 스크롤 양
global scroll_accel_rate := 1.1 ; 스크롤 가속도 비율

; 전역 변수로 현재 이동 거리 설정
global current_move := initial_move

; 마우스 이동 함수
Accel(x, y) {
    global current_move
    MouseMove(x * current_move, y * current_move, 0, "R")
    current_move := Min(current_move * accel_rate, max_move)
}

; CapsLock을 modifier로 사용하기 위한 설정
*CapsLock::
{
    KeyWait "CapsLock"
    if (A_PriorKey = "CapsLock")
        SetCapsLockState !GetKeyState("CapsLock", "T")
}

; 마우스 커서 이동 (직선 및 대각선)
CapsLock & i::MoveMouseCursor("i")
CapsLock & k::MoveMouseCursor("k")
CapsLock & j::MoveMouseCursor("j")
CapsLock & l::MoveMouseCursor("l")

MoveMouseCursor(key) {
    global current_move, initial_move, diagonal_factor, sleep_duration, decel_rate
    current_move := initial_move  ; 새 키 입력 시 이동 거리 초기화
    while GetKeyState(key, "P") {
        x := 0
        y := 0
        switch key {
            case "i": y := -1
            case "k": y := 1
            case "j": x := -1
            case "l": x := 1
        }
        if (x != 0 and (GetKeyState("i", "P") or GetKeyState("k", "P"))) {
            y := (key == "j") ? (GetKeyState("i", "P") ? -diagonal_factor : diagonal_factor) : (GetKeyState("i", "P") ? -diagonal_factor : diagonal_factor)
            x *= diagonal_factor
        }
        if (y != 0 and (GetKeyState("j", "P") or GetKeyState("l", "P"))) {
            x := (key == "i") ? (GetKeyState("j", "P") ? -diagonal_factor : diagonal_factor) : (GetKeyState("j", "P") ? -diagonal_factor : diagonal_factor)
            y *= diagonal_factor
        }
        Accel(x, y)
        Sleep sleep_duration
    }
    current_move *= decel_rate  ; 키를 놓았을 때 감속
}

; 마우스 클릭
CapsLock & r::Click()          ; CapsLock + r를 누르면 좌클릭
CapsLock & t::Click("right")   ; CapsLock + t를 누르면 우클릭

; 브라우저 탐색
CapsLock & f::Send("{XButton1}")  ; CapsLock + f를 누르면 뒤로가기
CapsLock & g::Send("{XButton2}")  ; CapsLock + g를 누르면 앞으로가기

; 가속도가 적용된 스크롤
CapsLock & u::  ; CapsLock + u를 누르면 위로 스크롤
{
    scroll_amount := initial_scroll
    while GetKeyState("u", "P") and GetKeyState("CapsLock", "P") {
        Click("WheelUp", scroll_amount)
        scroll_amount := Min(scroll_amount * scroll_accel_rate, max_scroll)
        Sleep 50
    }
}

CapsLock & o::  ; CapsLock + o를 누르면 아래로 스크롤
{
    scroll_amount := initial_scroll
    while GetKeyState("o", "P") and GetKeyState("CapsLock", "P") {
        Click("WheelDown", scroll_amount)
        scroll_amount := Min(scroll_amount * scroll_accel_rate, max_scroll)
        Sleep 50
    }
}

; CapsLock 키의 기본 기능 유지
#HotIf GetKeyState("CapsLock", "P")
i::Send "{Blind}{i}"
j::Send "{Blind}{j}"
k::Send "{Blind}{k}"
l::Send "{Blind}{l}"
r::Send "{Blind}{r}"
t::Send "{Blind}{t}"
u::Send "{Blind}{u}"
o::Send "{Blind}{o}"
f::Send "{Blind}{f}"
g::Send "{Blind}{g}"
#HotIf