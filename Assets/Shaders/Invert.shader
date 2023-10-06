Shader "Unlit/Invert"
{
    Properties
    {
        _Color ("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100
        
        Pass{
            ZWrite On
            ColorMask 0
        }

        Blend OneMinusDstColor OneMinusSrcAlpha 
        BlendOp Add
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 _Color;

            

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR0;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = _Color;
                return o;
            }

            half4 frag (v2f i) : COLOR
            {
                return i.color;
            }
            ENDCG
        }
    }
}
