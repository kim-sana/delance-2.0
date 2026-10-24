import asyncio
import contextlib
import socket
import subprocess
import sys
import time
from pathlib import Path

from playwright.async_api import async_playwright

ROOT = Path(__file__).resolve().parents[1]
WEB_DIR = ROOT / "build" / "web"
OUT_DIR = ROOT / "screenshots"
HOST = "127.0.0.1"
PORT = 8765

SCREENS = [
    "home",
    "search",
    "nowplaying",
    "lyrics",
    "queue",
    "library",
    "downloads",
    "capsule",
    "artist",
    "playlist",
    "settings",
]
THEMES = ["light", "dark"]


def wait_for_port(host: str, port: int, timeout: float = 15.0) -> None:
    deadline = time.time() + timeout
    while time.time() < deadline:
        with contextlib.closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as sock:
            sock.settimeout(0.4)
            if sock.connect_ex((host, port)) == 0:
                return
        time.sleep(0.2)
    raise RuntimeError(f"Server did not start on {host}:{port}")


async def capture() -> None:
    if not WEB_DIR.exists():
        raise SystemExit("build/web not found. Run: flutter build web --release")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    server = subprocess.Popen(
        [sys.executable, "-m", "http.server", str(PORT), "--bind", HOST],
        cwd=WEB_DIR,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    try:
        wait_for_port(HOST, PORT)
        async with async_playwright() as playwright:
            browser = await playwright.chromium.launch(
                channel="chrome",
                headless=True,
            )
            context = await browser.new_context(
                viewport={"width": 430, "height": 900},
                device_scale_factor=2,
            )
            page = await context.new_page()
            page.on(
                "console",
                lambda message: (
                    print(f"console[{message.type}]: {message.text}")
                    if message.type in {"error", "warning"}
                    else None
                ),
            )
            page.on("pageerror", lambda error: print(f"pageerror: {error}"))

            for theme in THEMES:
                for screen in SCREENS:
                    url = f"http://{HOST}:{PORT}/?screen={screen}&theme={theme}"
                    await page.goto(url, wait_until="load")
                    await page.wait_for_selector(
                        "flutter-view, flt-glass-pane",
                        timeout=45_000,
                    )
                    await page.wait_for_timeout(3200)
                    target = OUT_DIR / f"{theme}-{screen}.png"
                    await page.screenshot(path=str(target))
                    print(f"wrote {target.relative_to(ROOT)}")

            await browser.close()
    finally:
        server.terminate()
        with contextlib.suppress(Exception):
            server.wait(timeout=5)


if __name__ == "__main__":
    asyncio.run(capture())
