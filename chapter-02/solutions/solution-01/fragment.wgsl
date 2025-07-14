// Chapter 2 Solution 1: 基本的な時間アニメーションの応用
// 課題1-2-1「呼吸効果」の解答例

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let time = Time.duration;
    
    // 呼吸効果: ゆっくりとした明度変化
    let breathing = sin(time * 1.2) * 0.3 + 0.7;  // 0.4〜1.0の範囲で変化
    
    // 時間の2乗を利用した加速アニメーション
    let accelerated_time = time * time * 0.01;  // 徐々に速くなる
    
    // 複数の三角関数を組み合わせた複雑な色変化
    let red_phase = sin(accelerated_time * 0.8) * 0.4 + 0.6;
    let green_phase = sin(accelerated_time * 1.2 + 2.0) * 0.4 + 0.6;
    let blue_phase = cos(accelerated_time * 0.6 + 4.0) * 0.4 + 0.6;
    
    // 二重周期: 速い変化と遅い変化を重ね合わせ
    let fast_cycle = sin(time * 8.0) * 0.1;      // 速い変化
    let slow_cycle = sin(time * 0.5) * 0.2;      // 遅い変化
    let combined_cycle = fast_cycle + slow_cycle;
    
    // 最終的な色の計算
    let final_red = (red_phase + combined_cycle) * breathing;
    let final_green = (green_phase + combined_cycle * 0.8) * breathing;
    let final_blue = (blue_phase + combined_cycle * 0.6) * breathing;
    
    // 色の範囲を0〜1に制限
    let color = vec3(
        clamp(final_red, 0.0, 1.0),
        clamp(final_green, 0.0, 1.0),
        clamp(final_blue, 0.0, 1.0)
    );
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解答例の特徴:
// 1. 呼吸効果: sin(time * 1.2) で穏やかな明度変化
// 2. 加速アニメーション: time * time で時間の2乗を利用
// 3. 複雑な色変化: 各色成分に異なる周期と位相を設定
// 4. 二重周期: 速い変化と遅い変化の重ね合わせ
// 5. 範囲制限: clamp()で色の値を適切な範囲に制限
//
// 学習のポイント:
// - 時間の非線形変化 (time * time) の活用
// - 複数の周期的変化の組み合わせ
// - 色の範囲管理の重要性
// - 視覚的に心地よい変化の速度調整