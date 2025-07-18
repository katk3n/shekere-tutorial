// Chapter 3 Solution 2: 数学的パターンの創作 - 解答例
// 演習課題2の解答例を統合したバージョン

const PI = 3.14159265359;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 課題選択（0-8の範囲で変更してください）
    let task = i32(time * 0.15) % 9;
    
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    let normalized_angle = (angle + PI) / (2.0 * PI);
    
    var pattern = 0.0;
    
    // 2-1. 距離関数の応用
    if (task == 0) {
        // 2-1-1. パルス円
        let pulse_radius = sin(time * 2.0) * 0.3 + 0.5;
        pattern = 1.0 - step(distance, pulse_radius);
    } else if (task == 1) {
        // 2-1-2. 多重同心円
        let center1 = vec2(-0.3, 0.0);
        let center2 = vec2(0.3, 0.0);
        let center3 = vec2(0.0, 0.3);
        
        let dist1 = length(uv - center1);
        let dist2 = length(uv - center2);
        let dist3 = length(uv - center3);
        
        let ring1 = fract(dist1 * 8.0);
        let ring2 = fract(dist2 * 8.0);
        let ring3 = fract(dist3 * 8.0);
        
        pattern = min(min(ring1, ring2), ring3);
    } else if (task == 2) {
        // 2-1-3. 波動円
        let wave_radius = 0.5 + sin(angle * 8.0) * 0.2;
        pattern = 1.0 - smoothstep(wave_radius - 0.05, wave_radius + 0.05, distance);
    }
    
    // 2-2. 角度関数の応用
    else if (task == 3) {
        // 2-2-1. 花びらパターン
        let petal_count = 8.0;
        let petal_radius = 0.3 + sin(angle * petal_count) * 0.2;
        pattern = 1.0 - smoothstep(petal_radius - 0.05, petal_radius + 0.05, distance);
    } else if (task == 4) {
        // 2-2-2. 螺旋パターン
        let spiral_angle = normalized_angle + distance * 10.0;
        pattern = fract(spiral_angle);
        pattern = smoothstep(0.0, 0.1, pattern) * smoothstep(0.9, 0.8, pattern);
    } else if (task == 5) {
        // 2-2-3. 分割円
        let segments = 12.0;
        let segment_pattern = fract(normalized_angle * segments);
        let circle_mask = 1.0 - smoothstep(0.6, 0.7, distance);
        pattern = smoothstep(0.0, 0.1, segment_pattern) * 
                 smoothstep(1.0, 0.9, segment_pattern) * circle_mask;
    }
    
    // 2-3. 距離と角度の組み合わせ
    else if (task == 6) {
        // 2-3-1. 極座標グリッド
        let radial_lines = fract(normalized_angle * 16.0);
        let circular_lines = fract(distance * 12.0);
        let radial_pattern = smoothstep(0.0, 0.05, radial_lines) * smoothstep(0.95, 0.9, radial_lines);
        let circular_pattern = smoothstep(0.0, 0.05, circular_lines) * smoothstep(0.95, 0.9, circular_lines);
        pattern = max(radial_pattern, circular_pattern);
    } else if (task == 7) {
        // 2-3-2. ダーツボード
        let rings = floor(distance * 6.0);
        let segments = floor(normalized_angle * 20.0);
        let ring_color = fract(rings * 0.5);
        let segment_color = fract(segments * 0.5);
        pattern = ring_color * segment_color;
    } else if (task == 8) {
        // 2-3-3. 万華鏡
        let symmetric_angle = abs(fract(normalized_angle * 6.0) - 0.5) * 2.0;
        let radial_wave = sin(distance * 15.0 + time * 2.0);
        let angular_wave = sin(symmetric_angle * 10.0 + time * 3.0);
        pattern = (radial_wave * angular_wave + 1.0) * 0.5;
    }
    
    // 色の計算
    let hue = fract(pattern + time * 0.1);
    let saturation = 0.8;
    let value = pattern;
    
    let red = (sin(hue * 6.28) + 1.0) * 0.5 * saturation * value;
    let green = (sin(hue * 6.28 + 2.09) + 1.0) * 0.5 * saturation * value;
    let blue = (sin(hue * 6.28 + 4.19) + 1.0) * 0.5 * saturation * value;
    
    let color = vec3(red, green, blue);
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解答例の説明:
//
// 2-1. 距離関数の応用:
// - パルス円: sin関数で半径を時間変化
// - 多重同心円: 複数の中心点からの距離計算
// - 波動円: 角度による半径の変化
//
// 2-2. 角度関数の応用:
// - 花びらパターン: sin(angle * 数)で花びら形状
// - 螺旋パターン: 角度 + 距離で螺旋効果
// - 分割円: 角度の分割で扇形
//
// 2-3. 距離と角度の組み合わせ:
// - 極座標グリッド: 放射線と同心円の組み合わせ
// - ダーツボード: 離散的な分割
// - 万華鏡: 対称性と波動の組み合わせ
//
// 実装のポイント:
// - smoothstep()で滑らかなエッジ
// - fract()で周期的なパターン
// - 時間による動的な変化
// - HSV風の色空間で美しい色変化