// 演習 1: 基本光源
// 「インタラクティブ光現象 - Interactive Light Phenomena」作品への第1ステップ
// テーマ: 「最初の光 - The First Light」
// 目標: MouseCoords()とlength()を使ってマウスに追従する美しい光源を作成する

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let mouse = MouseCoords();
    
    // マウス位置からの距離を計算
    let distance = length(uv - mouse);
    
    // 光の基本パラメータ
    let light_radius = 0.4;                    // 光の半径
    let falloff_power = 3.0;                   // 減衰の急峻さ
    
    // 距離に基づく光の強度計算
    let normalized_distance = clamp(distance / light_radius, 0.0, 1.0);
    let light_intensity = pow(1.0 - normalized_distance, falloff_power);
    
    // 暖かい光の色彩
    let light_color = vec3(1.0, 0.9, 0.7);    // 暖色系の光
    
    // 最終的な光の色を計算
    let final_color = light_color * light_intensity;
    
    return vec4(ToLinearRgb(final_color), 1.0);
}

// 【技術ポイント】:
// - MouseCoords(): マウスの正規化座標を取得（-1.0〜1.0の範囲）
// - length(uv - mouse): マウス位置からピクセルへの距離を計算
// - clamp(): 距離を0.0〜1.0の範囲に正規化
// - pow(): 指数関数による滑らかな減衰カーブ
// - 暖色系の光色による自然な光の表現

// 【実験してみよう】:
// 1. 光の半径を変更: light_radius を 0.2, 0.6, 0.8 など
// 2. 減衰の急峻さを変更: falloff_power を 1.5, 4.0, 6.0 など
// 3. 光の色を変更: 冷色系 vec3(0.7, 0.9, 1.0) や純白 vec3(1.0, 1.0, 1.0)
// 4. 複数の要素を組み合わせて理想的な光を作成

// 【次のステップへの準備】:
// このコードは演習2で継承・拡張されます：
// - この基本光源を保持
// - 固定位置の光源を複数追加
// - 光源間の相互作用を実装