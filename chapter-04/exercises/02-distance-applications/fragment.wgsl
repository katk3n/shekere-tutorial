// 演習 2: 光の星座
// 「インタラクティブ光現象 - Interactive Light Phenomena」作品への第2ステップ
// テーマ: 「天の川の誕生 - Birth of the Milky Way」
// 目標: 前ステップの基本光源に固定位置の光源を追加し、美しい光の星座を構成する

// 【新規追加】汎用光源関数
fn create_light(uv: vec2<f32>, center: vec2<f32>, radius: f32, 
               intensity: f32, color: vec3<f32>) -> vec3<f32> {
    let distance = length(uv - center);
    let normalized_distance = clamp(distance / radius, 0.0, 1.0);
    let light_strength = pow(1.0 - normalized_distance, 3.0) * intensity;
    return color * light_strength;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // 【前ステップから継承】基本的なマウス追従光源
    // 演習1の基本光源システムを関数形式で再実装
    let main_light_radius = 0.4;
    let main_light_color = vec3(1.0, 0.9, 0.7);    // 暖色系のメイン光源
    let mouse_light = create_light(uv, mouse, main_light_radius, 1.0, main_light_color);
    
    // 【新規追加】固定位置の星座光源
    // 画面上にバランスよく配置された複数の光源
    let star1 = create_light(uv, vec2(-0.6, 0.4), 0.2, 0.7, vec3(0.8, 0.9, 1.0));   // 青白い星
    let star2 = create_light(uv, vec2(0.5, -0.3), 0.15, 0.6, vec3(1.0, 0.8, 0.6));  // 暖かい星
    let star3 = create_light(uv, vec2(0.0, 0.6), 0.25, 0.5, vec3(0.9, 0.7, 1.0));   // 紫の星
    let star4 = create_light(uv, vec2(-0.3, -0.5), 0.18, 0.4, vec3(0.7, 1.0, 0.8)); // 緑がかった星
    
    // 【新規追加】全光源の合成
    // 加算による光の組み合わせで美しい星座を形成
    var total_light = vec3(0.0, 0.0, 0.0);
    
    // メイン光源（最も明るく、動的）
    total_light += mouse_light;
    
    // 固定星座光源（中程度の明度、静的）
    total_light += star1;
    total_light += star2;
    total_light += star3;
    total_light += star4;
    
    return vec4(ToLinearRgb(total_light), 1.0);
}

// 【技術ポイント】:
// - 前ステップから継承: マウス追従による基本光源システム
// - create_light(): パラメータ化された再利用可能な光源関数
// - 固定座標: vec2(-0.6, 0.4)などによる戦略的配置
// - 光源の個性化: 異なる半径・強度・色による多様性
// - 加算合成: total_light += で光を重ね合わせ
// - 光の階層: メイン光源 > 副次光源のバランス

// 【実験してみよう】:
// 1. 光源の数を変更: star5, star6を追加して光の密度を上げる
// 2. 配置パターン変更: 円形配置 vec2(cos(angle), sin(angle))を試す
// 3. 色の調和を変更: 補色関係や単色グラデーションを試す
// 4. 強度バランス変更: メイン光源を0.8に下げて固定光源を目立たせる
// 5. 半径の調整: 大きな光源と小さな光源を混在させる

// 【次のステップへの準備】:
// このコードは演習3で継承・拡張されます：
// - この光の星座システムを保持
// - 時間による動的な色彩変化を追加
// - 光源間の色彩相互作用を実装