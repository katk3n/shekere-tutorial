// Chapter 3 Solution 1: 座標変換の応用 - 解答例
// 演習課題1の解答例を統合したバージョン
// 円と格子パターンで座標変換の効果を視覚化

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = NormalizedCoords(in.position.xy);
    let time = Time.duration;
    
    // 課題選択（0-9の範囲で変更してください）
    let task = i32(time * 0.2) % 10;
    
    var transformed_uv = uv;
    
    // 0. デフォルト状態（変換なし）
    if (task == 0) {
        // 変換なし - 元の座標をそのまま使用
        transformed_uv = uv;
    }
    
    // 1-1. 座標の対称化
    else if (task == 1) {
        // 1-1-1. 水平対称
        transformed_uv = vec2(abs(uv.x), uv.y);
    } else if (task == 2) {
        // 1-1-2. 垂直対称
        transformed_uv = vec2(uv.x, abs(uv.y));
    } else if (task == 3) {
        // 1-1-3. 中心対称
        transformed_uv = abs(uv);
    }
    
    // 1-2. 座標のスケーリング
    else if (task == 4) {
        // 1-2-1. 座標を2倍拡大（パターンは縮小して見える）
        transformed_uv = uv * 2.0;
    } else if (task == 5) {
        // 1-2-2. 座標を0.5倍縮小（パターンは拡大して見える）
        transformed_uv = uv * 0.5;
    } else if (task == 6) {
        // 1-2-3. 非等方スケーリング（X拡大、Y縮小 → パターンはX縮小、Y拡大）
        transformed_uv = vec2(uv.x * 2.0, uv.y * 0.5);
    }
    
    // 1-3. 座標の移動
    else if (task == 7) {
        // 1-3-1. 座標を右に移動（パターンは左に移動して見える）
        transformed_uv = uv + vec2(0.5, 0.0);
    } else if (task == 8) {
        // 1-3-2. 座標を左上に移動（パターンは右下に移動して見える）
        transformed_uv = uv + vec2(-0.3, 0.3);
    } else if (task == 9) {
        // 1-3-3. 円形移動
        let offset = vec2(cos(time), sin(time)) * 0.3;
        transformed_uv = uv + offset;
    }
    
    // 複数の円で座標変換を視覚化
    // 中心の円
    let center_circle = 1.0 - smoothstep(0.15, 0.2, length(transformed_uv));
    
    // 右上の円
    let top_right_pos = vec2(0.4, 0.4);
    let top_right_circle = 1.0 - smoothstep(0.1, 0.15, length(transformed_uv - top_right_pos));
    
    // 左下の円
    let bottom_left_pos = vec2(-0.4, -0.4);
    let bottom_left_circle = 1.0 - smoothstep(0.1, 0.15, length(transformed_uv - bottom_left_pos));
    
    // 右側の円
    let right_pos = vec2(0.6, 0.0);
    let right_circle = 1.0 - smoothstep(0.08, 0.12, length(transformed_uv - right_pos));
    
    // 円の合成
    let circles = center_circle + top_right_circle + bottom_left_circle + right_circle;
    
    // 色の計算
    let base_color = vec3(0.1, 0.1, 0.2);  // 暗い背景色
    let circle_color = vec3(0.8, 0.4, 1.0);  // 紫系の円の色
    
    let color = mix(base_color, circle_color, clamp(circles, 0.0, 1.0));
    
    return vec4(ToLinearRgb(color), 1.0);
}

// 解答例の説明:
// 
// 視覚化方法:
// - 複数の円: 座標変換の効果を分かりやすく表示
// - 中心の円(大)、右上の円、左下の円、右側の円
// 
// 0. デフォルト状態:
// - 変換なし: 元の座標配置を確認
// - 比較の基準として重要
//
// 1-1. 座標の対称化:
// - abs()関数で負の値を正の値に変換
// - 水平対称 (abs(uv.x)): 右半分が左半分に複製される
//   → 右上の円と右側の円が、左上と左側にも現れる
// - 垂直対称 (abs(uv.y)): 上半分が下半分に複製される
//   → 右上の円が右下にも現れる
// - 中心対称 (abs(uv)): 第1象限が他の3象限に複製される
//   → 右上の円が左上、左下、右下の4箇所に現れる
//
// 1-2. 座標のスケーリング:
// - 乗算でスケーリング（重要: 座標系のスケーリングとパターンのスケーリングは逆関係）
// - 座標を2倍拡大 (* 2.0): パターンが縮小して見える
// - 座標を0.5倍縮小 (* 0.5): パターンが拡大して見える  
// - 非等方 (X*2.0, Y*0.5): パターンはX方向に縮小、Y方向に拡大（楕円形）
//
// スケーリングの重要な概念:
// - 座標系を拡大すると、相対的にパターンが縮小して見える
// - 座標系を縮小すると、相対的にパターンが拡大して見える
//
// 1-3. 座標の移動:
// - 加算で移動（重要: 座標系の移動とパターンの移動は逆方向）
// - 座標を右に移動 (+ vec2(0.5, 0.0)): パターンが左に移動して見える
// - 座標を左上に移動 (+ vec2(-0.3, 0.3)): パターンが右下に移動して見える
// - 円形移動: 座標が円を描いて移動
//
// 座標変換の重要な概念:
// - 座標系を移動させると、パターンは逆方向に移動して見える
// - 座標系をスケーリングすると、パターンは逆の比率でスケーリングされて見える
// - これは座標変換の基本的な性質（座標系とオブジェクトの相対関係）
//
// 時間による課題の切り替え:
// - 5秒ごとに異なる課題を表示（デフォルト状態から開始）
// - 変換前後の比較で理解を深める