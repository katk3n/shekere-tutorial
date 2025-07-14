// Chapter 4 Example 2: カーソル追従オーブ効果
// マウスカーソルに追従する光るオーブを表示するシェーダー

// オーブ効果を生成する関数
fn orb(p: vec2<f32>, p0: vec2<f32>, r: f32, col: vec3<f32>) -> vec3<f32> {
    // p: 現在のピクセル位置
    // p0: オーブの中心位置
    // r: オーブの半径
    // col: オーブの色
    
    // 中心からの距離を計算し、半径に基づいて強度を決定
    let t = clamp(1.0 + r - length(p - p0), 0.0, 1.0);
    
    // 16乗により急激なフォールオフ（境界がはっきりした光の効果）
    return vec3(pow(t, 16.0) * col);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    // 現在のピクセルの正規化座標を取得
    let uv = NormalizedCoords(in.position.xy);
    
    // マウスの正規化座標を取得
    let mouse = MouseCoords();
    
    // オーブの色を定義（鮮やかな緑色）
    let green = vec3(0.0, 1.0, 0.0);
    
    // 背景色（黒）
    let black = vec3(0.0, 0.0, 0.0);
    
    // 背景色から開始
    var col = black;
    
    // マウス位置にオーブを追加
    // 半径0.07の緑色オーブを作成
    col += orb(uv, mouse, 0.07, green);
    
    // 色空間を変換して出力
    return vec4(ToLinearRgb(col), 1.0);
}

// 期待される動作：
// - マウスを動かすと緑色の光る球がカーソルに追従する
// - オーブの中心が最も明るく、外側に向かって滑らかに暗くなる
// - 背景は黒色で、オーブのみが光って見える