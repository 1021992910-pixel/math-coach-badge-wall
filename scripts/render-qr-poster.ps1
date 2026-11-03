param(
  [string]$QrPath = 'C:\Users\10219\Documents\Codex\2026-11-02\ck\outputs\数学讲题陪练_首版资料包\数学讲题陪练_独立徽章墙二维码.png',
  [string]$OutputPath = 'C:\Users\10219\Documents\Codex\2026-11-02\ck\outputs\数学讲题陪练_首版资料包\数学讲题陪练（三年级上）_公益学习入口二维码.png'
)

Add-Type -AssemblyName System.Drawing

$titleFontPath = 'E:\AI青少年课程\Codex\02_Codex自用资料库\04_图片与海报制作标准\可商用字体库\01_艺术标题\寒蝉全圆体_ChillRoundF\ChillRoundF-v3.0.ttf'
$bodyFontPath = 'E:\AI青少年课程\Codex\02_Codex自用资料库\04_图片与海报制作标准\可商用字体库\02_温暖副标题\霞鹜文楷_LXGWWenKai\LXGWWenKai-Medium-v1.522.ttf'

function New-RoundedPath([float]$x,[float]$y,[float]$w,[float]$h,[float]$r) {
  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $d = $r * 2
  $path.AddArc($x,$y,$d,$d,180,90)
  $path.AddArc($x+$w-$d,$y,$d,$d,270,90)
  $path.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90)
  $path.AddArc($x,$y+$h-$d,$d,$d,90,90)
  $path.CloseFigure()
  return $path
}

function Draw-CenteredText($graphics,[string]$text,$font,$brush,[float]$centerX,[float]$y) {
  $size = $graphics.MeasureString($text,$font)
  $graphics.DrawString($text,$font,$brush,$centerX-($size.Width/2),$y)
}

$fonts = [System.Drawing.Text.PrivateFontCollection]::new()
$fonts.AddFontFile($titleFontPath)
$fonts.AddFontFile($bodyFontPath)
$titleFamily = $fonts.Families | Where-Object Name -eq '寒蝉全圆体' | Select-Object -First 1
$bodyFamily = $fonts.Families | Where-Object Name -eq '霞鹜文楷 Medium' | Select-Object -First 1

$bitmap = [System.Drawing.Bitmap]::new(1080,1350,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$graphics.Clear([System.Drawing.ColorTranslator]::FromHtml('#F3F7FB'))

$cardPath = New-RoundedPath 40 40 1000 1270 42
$cardBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$graphics.FillPath($cardBrush,$cardPath)

$headerPath = New-RoundedPath 40 40 1000 305 42
$headerBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#216B62'))
$graphics.FillPath($headerBrush,$headerPath)
$graphics.FillRectangle($headerBrush,40,285,1000,60)

$whiteBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$lightBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#DDEFF3'))
$tealBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#216B62'))
$mutedBrush = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml('#7B8DA8'))

$titleFont = [System.Drawing.Font]::new($titleFamily,61,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
$subtitleFont = [System.Drawing.Font]::new($bodyFamily,38,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
$sloganFont = [System.Drawing.Font]::new($titleFamily,42,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
$actionFont = [System.Drawing.Font]::new($titleFamily,40,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)
$footFont = [System.Drawing.Font]::new($bodyFamily,27,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Pixel)

Draw-CenteredText $graphics '数学讲题陪练' $titleFont $whiteBrush 540 92
Draw-CenteredText $graphics '（三年级上）公益学习入口' $subtitleFont $lightBrush 540 210
Draw-CenteredText $graphics '讲得清，才是真的学会' $sloganFont $tealBrush 540 382

$qr = [System.Drawing.Image]::FromFile($QrPath)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$graphics.DrawImage($qr,[System.Drawing.Rectangle]::new(240,490,600,600))

Draw-CenteredText $graphics '扫码开始讲题' $actionFont $tealBrush 540 1150
Draw-CenteredText $graphics '费曼学习法 · 每天讲清一道题' $footFont $mutedBrush 540 1235

$outDir = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$bitmap.Save($OutputPath,[System.Drawing.Imaging.ImageFormat]::Png)

$qr.Dispose()
$titleFont.Dispose(); $subtitleFont.Dispose(); $sloganFont.Dispose(); $actionFont.Dispose(); $footFont.Dispose()
$whiteBrush.Dispose(); $lightBrush.Dispose(); $tealBrush.Dispose(); $mutedBrush.Dispose()
$headerBrush.Dispose(); $cardBrush.Dispose(); $headerPath.Dispose(); $cardPath.Dispose()
$graphics.Dispose(); $bitmap.Dispose(); $fonts.Dispose()

Write-Output $OutputPath
