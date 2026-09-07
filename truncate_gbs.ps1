param(
    [string]$in_name,
    [string]$out_name
)

$in = [System.IO.File]::OpenRead($in_name)
$out = [System.IO.File]::OpenWrite($out_name)

$header = New-Object byte[] 112
$in.Read($header, 0, 112) | Out-Null
$out.Write($header, 0, 112)

$b = $in.ReadByte()
while ($b -eq 0) {
    $b = $in.ReadByte()
}

$buffer = New-Object byte[] 4096
$out.Write([byte]$b, 0, 1)
while (($read = $in.Read($buffer, 0, $buffer.Length)) -gt 0) {
    $out.Write($buffer, 0, $read)
}

$in.Close()
$out.Close()
