/*!
 * @brief チェッカーボードワイプ
 */

cbuffer cb : register(b0)
{
    float4x4 mvp;       // MVP行列
    float4 mulColor;    // 乗算カラー
};

cbuffer WipeCB : register(b1)
{
    float wipeSize;     // ワイプサイズ
};

struct VSInput
{
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct PSInput
{
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
};

Texture2D<float4> colorTexture : register(t0); // カラーテクスチャ
sampler Sampler : register(s0);

PSInput VSMain(VSInput In)
{
    PSInput psIn;
    psIn.pos = mul(mvp, In.pos);
    psIn.uv = In.uv;
    return psIn;
}

float4 PSMain(PSInput In) : SV_Target0
{
    float4 color = colorTexture.Sample(Sampler, In.uv);

    // step-1 チェッカーボードワイプを実装する
    float t = floor(In.pos.y / 128.0f); // 小数点を捨てて行番号を求める
    t = fmod(t, 2.0f); // 行を偶数と奇数に分ける
    t = (int)fmod(In.pos.x + 64.0f * t, 128.0f); // 奇数ならずらしてワイプ
    clip(t - wipeSize);

    return color;
}
