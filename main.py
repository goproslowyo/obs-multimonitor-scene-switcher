import time
import pyautogui
from screeninfo import get_monitors
from obswebsocket import obsws, requests
from obswebsocket.exceptions import ConnectionFailure


# OBS WebSocket config
HOST = 'localhost'
PORT = 4455
PASSWORD = ''


def get_monitor_scene_map():
    monitors = get_monitors()
    scene_map = {}
    for i, m in enumerate(monitors):
        scene_map[i] = {
            'scene_name': f'Monitor{i+1}',
            'bounds': (m.x, m.y, m.width, m.height)
        }
    return scene_map


def detect_active_monitor(x, y, monitor_map):
    for idx, info in monitor_map.items():
        mx, my, mw, mh = info['bounds']
        if mx <= x < mx + mw and my <= y < my + mh:
            return idx
    return None


def main():
    monitor_map = get_monitor_scene_map()
    print("Detected monitors:")
    for idx, info in monitor_map.items():
        print(f"Monitor {idx+1}: Scene '{info['scene_name']}', Bounds: {info['bounds']}")

    ws = obsws(HOST, PORT, PASSWORD)

    try:
        ws.connect()
    except ConnectionFailure as e:
        print("\n❌ Could not connect to OBS.")
        print("Make sure OBS is running and the WebSocket server is enabled.")
        print("If you've set a password in OBS, make sure it matches the script.")
        print(f"\n[Technical detail: {e}]\n")
        input("Press any key twice to exit...")
        return

    last_monitor = None

    try:
        while True:
            x, y = pyautogui.position()
            current_monitor = detect_active_monitor(x, y, monitor_map)
            if current_monitor is not None and current_monitor != last_monitor:
                scene_name = monitor_map[current_monitor]['scene_name']
                print(f"Switching to scene: {scene_name}")
                ws.call(requests.SetCurrentProgramScene(sceneName=scene_name))
                last_monitor = current_monitor
            time.sleep(0.2)
    except KeyboardInterrupt:
        print("Exiting.")
    finally:
        ws.disconnect()


if __name__ == '__main__':
    main()
