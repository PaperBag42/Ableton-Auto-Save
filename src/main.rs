use std::thread::sleep;
use std::time::Duration;

use anyhow::{bail, Context, Result};
use clap::Parser;
use enigo::{Direction, Enigo, Key, Keyboard, Settings};

#[derive(Parser)]
#[command(author, version, about = "Trigger Ableton Live save actions from the command line.", long_about = None)]
struct Args {
    /// Send Collect All And Save instead of a simple save
    #[arg(short, long)]
    collect_all: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let title = active_window_title()
        .context("Unable to determine the active window title")?;

    if !is_ableton_window(&title) {
        bail!("Active window is not Ableton Live. Current active window: {title}");
    }

    println!("Detected Ableton Live window: {title}");
    if args.collect_all {
        println!("Triggering Collect All And Save...");
    } else {
        println!("Triggering Save...");
    }

    trigger_save(args.collect_all)?;
    Ok(())
}

fn is_ableton_window(title: &str) -> bool {
    title.to_lowercase().contains("ableton live")
}

fn trigger_save(collect_all: bool) -> Result<()> {
    let mut enigo = Enigo::new(&Settings::default())
        .context("Unable to initialize Enigo input controller")?;

    if collect_all {
        enigo.key(Key::Alt, Direction::Press)?;
        enigo.key(Key::Unicode('f'), Direction::Click)?;
        enigo.key(Key::Alt, Direction::Release)?;
        sleep(Duration::from_millis(200));

        enigo.key(Key::Unicode('c'), Direction::Click)?;
        sleep(Duration::from_millis(200));

        enigo.key(Key::Return, Direction::Click)?;
    } else {
        enigo.key(Key::Control, Direction::Press)?;
        enigo.key(Key::Unicode('s'), Direction::Click)?;
        enigo.key(Key::Control, Direction::Release)?;
    }

    Ok(())
}

#[cfg(target_os = "windows")]
fn active_window_title() -> Option<String> {
    use windows::Win32::Foundation::HWND;
    use windows::Win32::UI::WindowsAndMessaging::{GetForegroundWindow, GetWindowTextLengthW, GetWindowTextW};

    unsafe {
        let hwnd: HWND = GetForegroundWindow();
        if hwnd.0 == 0 {
            return None;
        }

        let length = GetWindowTextLengthW(hwnd);
        if length == 0 {
            return None;
        }

        let mut buffer: Vec<u16> = vec![0; (length + 1) as usize];
        let read = GetWindowTextW(hwnd, &mut buffer);
        if read == 0 {
            return None;
        }

        String::from_utf16_lossy(&buffer[..read as usize]).into()
    }
}

#[cfg(not(target_os = "windows"))]
fn active_window_title() -> Option<String> {
    None
}
