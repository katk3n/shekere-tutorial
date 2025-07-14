// Chapter 4 Solution 2: 距離計算の応用解答例
// 演習課題2のオーブ効果とその応用を示すシェーダー

// 基本的なオーブ効果を生成する関数
fn orb(p: vec2<f32>, p0: vec2<f32>, r: f32, col: vec3<f32>) -> vec3<f32> {
    let t = clamp(1.0 + r - length(p - p0), 0.0, 1.0);
    return vec3(pow(t, 16.0) * col);
}

// 時間による変化を持つオーブ効果
fn pulsingOrb(p: vec2<f32>, p0: vec2<f32>, r: f32, col: vec3<f32>, time: f32) -> vec3<f32> {
    let pulse = sin(time * 3.0) * 0.3 + 0.7;  // 0.4〜1.0の範囲で振動
    let adjusted_radius = r * pulse;
    return orb(p, p0, adjusted_radius, col);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    let time = Time.duration;
    
    // 解答例を選択（以下のいずれかのコメントアウトを解除）
    
    // ===== 2-1-1. 赤色のオーブ =====
    // let red = vec3(1.0, 0.0, 0.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.07, red);
    
    // ===== 2-1-2. 青色のオーブ =====
    // let blue = vec3(0.0, 0.0, 1.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.07, blue);
    
    // ===== 2-1-3. 黄色のオーブ =====
    // let yellow = vec3(1.0, 1.0, 0.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.07, yellow);
    
    // ===== 2-1-4. サイズ変更例 =====
    // let green = vec3(0.0, 1.0, 0.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.1, green);  // 大きなオーブ
    
    // ===== 2-1-5. フォールオフ調整例 =====
    // fn softOrb(p: vec2<f32>, p0: vec2<f32>, r: f32, col: vec3<f32>) -> vec3<f32> {
    //     let t = clamp(1.0 + r - length(p - p0), 0.0, 1.0);
    //     return vec3(pow(t, 4.0) * col);  // 柔らかい効果
    // }
    // let green = vec3(0.0, 1.0, 0.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += softOrb(uv, mouse, 0.07, green);
    
    // ===== 2-2-1. 固定位置の四隅オーブ =====
    // let corner1 = vec2(-0.8, -0.8);
    // let corner2 = vec2(0.8, -0.8);
    // let corner3 = vec2(-0.8, 0.8);
    // let corner4 = vec2(0.8, 0.8);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, corner1, 0.05, vec3(1.0, 0.0, 0.0));  // 赤
    // col += orb(uv, corner2, 0.05, vec3(0.0, 1.0, 0.0));  // 緑
    // col += orb(uv, corner3, 0.05, vec3(0.0, 0.0, 1.0));  // 青
    // col += orb(uv, corner4, 0.05, vec3(1.0, 1.0, 0.0));  // 黄
    
    // ===== 2-2-2. マウス追従 + 固定オーブ =====
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.07, vec3(0.0, 1.0, 0.0));    // マウス追従（緑）
    // col += orb(uv, vec2(0.0, 0.0), 0.05, vec3(1.0, 0.0, 0.0));  // 中央固定（赤）
    
    // ===== 2-2-3. マウス周辺のオーブ =====
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, 0.07, vec3(1.0, 1.0, 1.0));  // メイン（白）
    // col += orb(uv, mouse + vec2(0.15, 0.0), 0.04, vec3(1.0, 0.0, 0.0));  // 右（赤）
    // col += orb(uv, mouse - vec2(0.15, 0.0), 0.04, vec3(0.0, 0.0, 1.0));  // 左（青）
    
    // ===== 2-3-1. グラデーション効果 =====
    // let distance = length(uv - mouse);
    // let color1 = vec3(1.0, 0.0, 0.0);  // 赤
    // let color2 = vec3(0.0, 0.0, 1.0);  // 青
    // let factor = clamp(distance / 1.4, 0.0, 1.0);
    // let col = mix(color1, color2, factor);
    
    // ===== 2-3-2. パルス効果 =====
    // let pulse = sin(time * 4.0) * 0.5 + 0.5;
    // let radius = 0.05 + 0.03 * pulse;
    // let green = vec3(0.0, 1.0, 0.0);
    // var col = vec3(0.0, 0.0, 0.0);
    // col += orb(uv, mouse, radius, green);
    
    // ===== 発展例: 複合効果 =====
    var col = vec3(0.0, 0.0, 0.0);
    
    // パルスするメインオーブ
    col += pulsingOrb(uv, mouse, 0.07, vec3(1.0, 1.0, 1.0), time);
    
    // 回転するサブオーブ
    let angle = time * 2.0;
    let orbit_radius = 0.2;
    let sub_pos = mouse + vec2(cos(angle), sin(angle)) * orbit_radius;
    col += orb(uv, sub_pos, 0.03, vec3(0.0, 1.0, 0.0));
    
    // 距離によるグラデーション背景
    let distance = length(uv - mouse);
    let background_color = vec3(0.0, 0.0, 0.1) * (1.0 - clamp(distance / 1.0, 0.0, 1.0));
    col += background_color;
    
    return vec4(ToLinearRgb(col), 1.0);
}

// 使用方法:
// 1. 上記のコメントアウトを1つずつ解除して効果を確認
// 2. orb関数のパラメータを変更して効果を調整
// 3. 複数の効果を組み合わせて独自パターンを作成

// 学習ポイント:
// - clamp() で値の範囲制限
// - pow() で指数関数による滑らかな変化
// - mix() で色のブレンド
// - sin() で周期的な変化
// - 複数のオーブの加算による複合効果