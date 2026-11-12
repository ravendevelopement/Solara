\
$ErrorActionPreference = "Stop"
$root = (Resolve-Path $PSScriptRoot).Path
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 5500)

try {
    $listener.Start()
    Write-Host ""
    Write-Host "SOLARA is running at http://localhost:5500" -ForegroundColor Green
    Write-Host "Keep this window open while using the website."
    Write-Host "Close this window to stop SOLARA."
    Start-Sleep -Milliseconds 500
    Start-Process "http://localhost:5500"

    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $stream = $client.GetStream()
            $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
            $requestLine = $reader.ReadLine()
            if ([string]::IsNullOrWhiteSpace($requestLine)) { $client.Close(); continue }

            while ($true) {
                $headerLine = $reader.ReadLine()
                if ($null -eq $headerLine -or $headerLine -eq "") { break }
            }

            $parts = $requestLine.Split(" ")
            $method = $parts[0]
            $urlPath = [System.Uri]::UnescapeDataString(($parts[1] -split "\?")[0])
            if ($urlPath -eq "/") { $urlPath = "/index.html" }

            $relative = $urlPath.TrimStart("/") -replace "/", [System.IO.Path]::DirectorySeparatorChar
            $fullPath = [System.IO.Path]::GetFullPath((Join-Path $root $relative))

            if (-not $fullPath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or
                -not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
                $status = "404 Not Found"
                $body = [System.Text.Encoding]::UTF8.GetBytes("Not found")
                $contentType = "text/plain; charset=utf-8"
            } else {
                $status = "200 OK"
                $body = [System.IO.File]::ReadAllBytes($fullPath)
                $extension = [System.IO.Path]::GetExtension($fullPath).ToLowerInvariant()
                $contentType = switch ($extension) {
                    ".html" { "text/html; charset=utf-8" }
                    ".css"  { "text/css; charset=utf-8" }
                    ".js"   { "application/javascript; charset=utf-8" }
                    ".txt"  { "text/plain; charset=utf-8" }
                    ".svg"  { "image/svg+xml" }
                    ".png"  { "image/png" }
                    ".jpg"  { "image/jpeg" }
                    ".jpeg" { "image/jpeg" }
                    ".webp" { "image/webp" }
                    ".ico"  { "image/x-icon" }
                    default { "application/octet-stream" }
                }
            }

            $header = "HTTP/1.1 $status`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nConnection: close`r`nCache-Control: no-store`r`n`r`n"
            $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            if ($method -ne "HEAD" -and $body.Length -gt 0) {
                $stream.Write($body, 0, $body.Length)
            }
            $stream.Flush()
        } catch {
            Write-Host "Request error: $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            $client.Close()
        }
    }
} catch {
    Write-Host "Could not start the local server: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "If port 5500 is already in use, close the other server and try again."
    Read-Host "Press Enter to close"
} finally {
    if ($listener) { $listener.Stop() }
}
