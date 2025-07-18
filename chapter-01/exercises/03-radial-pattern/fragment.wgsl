// 演習 3: 放射状パターンを加える
// 目標: 同心円に8方向の放射状ラインを追加する

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // UV座標と距離、角度を計算
    let uv = NormalizedCoords(in.position.xy);
    let distance = length(uv);
    let angle = atan2(uv.y, uv.x); // -π から π の範囲
    
    // 初期色を黒に設定
    var color = vec3(0.0);
    
    // 同心円パターン（前回と同じ）
    if distance < 0.3 {
        // 内側の円: 温かい赤
        color = vec3(1.0, 0.3, 0.1);
    } else if distance < 0.6 {
        // 中間のリング: 黄色
        color = vec3(1.0, 0.8, 0.0);
    } else if distance < 0.9 {
        // 外側のリング: オレンジ
        color = vec3(1.0, 0.5, 0.0);
    }
    
    // 放射状パターンの作成（8方向）
    let radial_lines = sin(angle * 4.0) * 0.5 + 0.5;
    let line_intensity = step(0.7, radial_lines);
    
    // ラインを白色で描画（中心の小さな円は除く）
    if line_intensity > 0.5 && distance > 0.1 {
        color = mix(color, vec3(1.0), 0.6);
    }
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解説:
// - atan2(uv.y, uv.x): UV座標から角度を計算
// - angle * 4.0: 4倍することで2π区間で8回の波を作成
// - sin(...) * 0.5 + 0.5: サインの結果を0〜1の範囲に変換
// - step(0.7, ...): 0.7以上で1、未満で0の二値化
// - mix(color, vec3(1.0), 0.6): 既存色と白を60%の強度で混合
// - distance > 0.1: 中心の小さな円は放射線から除外