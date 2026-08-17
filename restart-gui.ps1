# restart-gui.ps1 - detached dsh web restart for skin activation
# Kills the current web server (whatever PID owns port 3080), waits for the
# port to free, then relaunches via the proven launcher 启动dsh.bat.

$ErrorActionPreference = 'SilentlyContinue'

# 动态杀掉占用 3080 的进程树（不再硬编码 PID）
$conn = Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue
if ($conn) {
    $conn.OwningProcess | Sort-Object -Unique | ForEach-Object {
        taskkill /PID $_ /T /F | Out-Null
    }
}

$deadline = (Get-Date).AddSeconds(25)
while ((Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue) -and (Get-Date) -lt $deadline) {
    Start-Sleep -Milliseconds 500
}

Start-Process -FilePath 'D:\DEEPSEEK harness\启动dsh.bat' -WorkingDirectory 'D:\DEEPSEEK harness'
