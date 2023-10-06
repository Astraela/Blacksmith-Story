Shader "ISA/GrayScaler"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTexTrans ("Texture Transparency",Range(0.0,1.0)) = 0.1
        _Color ("Color", COLOR) = (1,1,1,1)
        _ColorTrans ("Color Transparency",Range(0.0,1.0)) = 0.1
        _minX ("Min X", float) = 0
        _maxX ("Max X", float) = 20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldSpacePos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float _MainTexTrans;
            float4 _Color;
            float _ColorTrans;
            float4 _MainTex_ST;
            float _minX = 0;
            float _maxX = 20;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldSpacePos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float range = abs(_maxX - _minX);
                float percentage = i.worldSpacePos.x/ range;

                col.rgb = (percentage,percentage,percentage) + (col*_MainTexTrans) + (_Color*_ColorTrans);

                return col;
            }
            ENDCG
        }
    }
}
