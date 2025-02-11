# Wallpaper-Rotator

## Linux Instructions

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fellipec/Wallpaper-Rotator/master/install.sh)"
```

## Windows instructions

## Setting Up Wallpaper Rotator in Windows Task Scheduler

To automatically update your wallpaper on Windows, create a Scheduled Task with the following settings:

### **General**
- **Name:** `Wallpaper Rotator`
- **Run only when user is logged on**
- **Run with highest privileges** (optional)

### **Trigger**
- **At log on** (or set a custom schedule)

### **Action**
- **Start a program**
- **Program/script:** `powershell.exe`
- **Arguments:**
  ```plaintext
  -WindowStyle Hidden -ExecutionPolicy Bypass -File "%APPDATA%\wallpaper-rotator\getwallpaper.ps1"
  ```

### **Additional Settings**
- Uncheck **"Start only on AC power"** (if desired)
- Allow manual runs and missed task execution

### **Test the Task**
- Right-click the task in Task Scheduler → **Run**

Now, your wallpaper will update **silently** at login or on schedule! 🚀

