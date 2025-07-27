// Chapter 2 Exercise 4: 最終螺旋作品の完成
// ステップ4: 前ステップを発展させて高度な螺旋作品を完成

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 中心からの距離と角度を計算
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x);
    
    // 前ステップの3つの時間アニメーション（保持）
    let circle_pattern = sin(distance * 8.0 - time * 2.0);
    let radial_pattern = sin(angle * 6.0 + time * 1.0);
    let spiral_pattern = sin(distance * 4.0 + angle * 3.0 + time * 1.5);
    
    // 前ステップを高度な構成に発展させる
    // 螺旋パターン: 距離と角度を組み合わせた螺旋効果
    let spiral_frequency = 6.0;  // 螺旋の密度
    let spiral_speed = 2.0;      // 螺旋の回転速度
    let enhanced_spiral = sin(distance * spiral_frequency + angle * 3.0 + time * spiral_speed);
    
    // 同心円パターン: 中心から広がる円形波動
    let circle_frequency = 12.0;  // 円の密度
    let circle_speed = 3.0;       // 円の拡散速度
    let enhanced_circle = sin(distance * circle_frequency - time * circle_speed);
    
    // 放射状パターン: 中心から放射状に広がる波動
    let radial_frequency = 8.0;   // 放射の本数
    let radial_speed = 1.5;       // 放射の変化速度
    let enhanced_radial = sin(angle * radial_frequency + time * radial_speed);
    
    // 複合パターン: 複数の波動を重ね合わせ（元の最終作品の構成）
    let combined_pattern = enhanced_spiral * 0.5 + enhanced_circle * 0.3 + enhanced_radial * 0.2;
    
    // 距離による減衰効果（中心が明るく、端が暗く）
    let attenuation = 1.0 - distance * 0.6;
    let final_intensity = (combined_pattern + 1.0) * 0.5 * attenuation;
    
    // 時間による色相変化（元の最終作品の色彩システム）
    let hue_shift = time * 0.2;
    let red = (sin(final_intensity * 6.28 + hue_shift) + 1.0) * 0.5;
    let green = (sin(final_intensity * 6.28 + hue_shift + 2.09) + 1.0) * 0.5;
    let blue = (sin(final_intensity * 6.28 + hue_shift + 4.19) + 1.0) * 0.5;
    
    // 最終的な色の計算
    let color = vec3(red, green, blue) * final_intensity;
    
    return vec4(ToLinearRgb(color), 1.0);
}

// このステップで学ぶこと:
// 1. 前ステップの3つの時間効果を統合・発展
// 2. 元の最終作品レベルの複合パターン作成
// 3. 螺旋パターン: distance * frequency + angle * 係数 で螺旋を生成
// 4. 同心円パターン: distance * frequency - time * speed で円形波動
// 5. 放射状パターン: angle * frequency で放射状の効果
// 6. 複合パターン: 複数の波動を重み付けして合成
// 7. 距離による減衰: 1.0 - distance * 係数 で自然な減衰
// 8. 色相変化: 時間による色の回転効果

// Chapter 2の完成:
// - ステップ1: 静的パターン（基礎）
// - ステップ2: 基本時間アニメーション（同心円移動、色変化）  
// - ステップ3: 複雑時間効果（螺旋、回転、色相回転）
// - ステップ4: 最終作品完成（元の複合螺旋パターン作品）
// 
// 学習のポイント:
// - length(uv)とatan2()の極座標系での活用
// - 複数の波動の重ね合わせ技術
// - 重み付け合成による効果の調整
// - 減衰効果による自然な表現
// - 色相変化による動的な色彩効果