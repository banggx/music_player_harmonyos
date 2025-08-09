export function hexToRGBA(hex: string): string[] {
  try {
    const cleanHex = hex.replace(/^#/, '').toUpperCase();

    if (!/^(?:[0-9A-F]{8}|[0-9A-F]{6})$/.test(cleanHex)) {
      throw new Error("Invalid hex color format");
    }

    const fullHex = cleanHex.length === 6 ? `FF${cleanHex}` : cleanHex;
    const alphaHex = fullHex.substring(0, 2);
    const redHex = fullHex.substring(2, 4);
    const greenHex = fullHex.substring(4, 6);
    const blueHex = fullHex.substring(6, 8);

    const alpha = Math.round((parseInt(alphaHex, 16) / 255) * 100);
    const red = parseInt(redHex, 16);
    const green = parseInt(greenHex, 16);
    const blue = parseInt(blueHex, 16);

    return [red.toString(), green.toString(), blue.toString(), alpha.toString()];
  } catch (error) {
    console.error("Hex to RGBA conversion error:", error);
    return ['0', '0', '0', '100'];
  }
}