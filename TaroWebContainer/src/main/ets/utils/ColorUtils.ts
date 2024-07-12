// Color name to hex map
export const colorNamesToHex: { [key: string]: string } = {
  "black": "#000000",
  "white": "#ffffff",
  "red": "#ff0000",
  "green": "#008000",
  "blue": "#0000ff",
  "yellow": "#ffff00",
  "cyan": "#00ffff",
  "magenta": "#ff00ff",
  // 你可以根据需要添加更多颜色
};

// Convert RGB to Hex
export function rgbToHex(r: number, g: number, b: number): string {
  return `#${((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1).toLowerCase()}`;
}

// Convert RGBA to Hex
export function rgbaToHex(r: number, g: number, b: number, a: number): string {
  return rgbToHex(r, g, b);
}

// Convert HSL to Hex
export function hslToHex(h: number, s: number, l: number): string {
  s /= 100;
  l /= 100;

  const k = (n: number) => (n + h / 30) % 12;
  const a = s * Math.min(l, 1 - l);
  const f = (n: number) => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));

  return rgbToHex(Math.round(f(0) * 255), Math.round(f(8) * 255), Math.round(f(4) * 255));
}

// Convert HSLA to Hex
function hslaToHex(h: number, s: number, l: number, a: number): string {
  return hslToHex(h, s, l);
}

/**
 * 将[rgb(red, green, blue)、rgba(red, green, blue, alpha)、hsl(hue, saturation, lightness)、hsla(hue, saturation, lightness, alpha)、颜色名称]这几种颜色表示都转换为16进制表示法。
 * @param color
 * @returns
 */
export function colorToHex(color: string): string {
  if (color.startsWith("#")) {
    if (color.length === 4) {
      return expandHex(color.toLowerCase())
    }
    // Already in hex format
    return color.toLowerCase()
  }

  if (color.startsWith("rgb")) {
    const rgba = color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+\.?\d*))?\)/);
    if (rgba) {
      const [_, r, g, b] = rgba.map(Number);
      return rgbToHex(r, g, b);
    }
  }

  if (color.startsWith("hsl")) {
    const hsla = color.match(/hsla?\((\d+),\s*(\d+)%?,\s*(\d+)%?(?:,\s*(\d+\.?\d*))?\)/);
    if (hsla) {
      const [_, h, s, l] = hsla.map(Number);
      return hslToHex(h, s, l);
    }
  }

  if (colorNamesToHex[color.toLowerCase()]) {
    return colorNamesToHex[color.toLowerCase()];
  }

  throw new Error("Unsupported color format");
}

/**
 * 匹配到缩写的颜色值时进行扩写，如 '#fff'扩写后为'#ffffff'
 * @param hex
 */
export function expandHex (hex) {
  return hex.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i, function (_m, r, g, b) {
    return '#' + r + r + g + g + b + b
  })
}

/**
 * 颜色反转，用于适配深色模式
 * @param color 颜色值
 */
export function invertColor (color: string) {
  // 扩展缩写的颜色值
  let hex = colorToHex(color)

  // 移除 # 符号
  hex = hex.replace('#', '')

  // 将十六进制转换为RGB
  let r = parseInt(hex.substring(0, 2), 16)
  let g = parseInt(hex.substring(2, 4), 16)
  let b = parseInt(hex.substring(4, 6), 16)

  // 反转RGB值
  r = 255 - r
  g = 255 - g
  b = 255 - b

  // 将RGB值转换回十六进制
  return '#' + (r.toString(16).padStart(2, '0')) + (g.toString(16).padStart(2, '0')) + (b.toString(16).padStart(2, '0'))
}

