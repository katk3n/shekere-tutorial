// Chapter 2 Example 3: 色の遷移アニメーション
// 中心からの距離に基づく虹色の循環アニメーション

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離を計算
    let distance = length(uv);
    
    // 距離と時間を組み合わせて色のサイクルを作成
    let color_cycle = distance * 2.0 + time * 0.5;
    
    // 0〜1の範囲に正規化して虹色を作成
    let hue = fract(color_cycle);
    
    // HSV色空間風の虹色を作成
    // 色相(hue)を0〜6の範囲に変換
    let hue_sector = hue * 6.0;
    
    var color = vec3(0.0);
    
    if (hue_sector < 1.0) {
        // 赤 → 黄
        color = vec3(1.0, hue_sector, 0.0);
    } else if (hue_sector < 2.0) {
        // 黄 → 緑
        color = vec3(2.0 - hue_sector, 1.0, 0.0);
    } else if (hue_sector < 3.0) {
        // 緑 → シアン
        color = vec3(0.0, 1.0, hue_sector - 2.0);
    } else if (hue_sector < 4.0) {
        // シアン → 青
        color = vec3(0.0, 4.0 - hue_sector, 1.0);
    } else if (hue_sector < 5.0) {
        // 青 → マゼンタ
        color = vec3(hue_sector - 4.0, 0.0, 1.0);
    } else {
        // マゼンタ → 赤
        color = vec3(1.0, 0.0, 6.0 - hue_sector);
    }
    
    // 距離に応じて明度を調整（中心が明るく、端が暗く）
    let brightness = 1.0 - distance * 0.3;
    color = color * brightness;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 実験してみよう:
// 1. 距離係数を変える: * 2.0 を他の値に変更
// 2. 時間係数を変える: * 0.5 を他の値に変更
// 3. 明度調整を変える: * 0.3 を他の値に変更
// 4. 角度による色変化: atan2(uv.y, uv.x) を使用