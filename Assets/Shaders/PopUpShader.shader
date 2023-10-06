Shader "ISA/PopUpShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SizeDifference ("Size Difference", float) = 1
        _Hover ("Hovering", float) = 0
        _CentrePoint ("Centre", Vector) = (0, 0, 0, 0)
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _SizeDifference;
            float _Hover;
            float4 _CentrePoint;
            
            float4 IncreaseSize (float4 vertex){
                float time = (1 + sin(_Time.w))/2;
                float4 castToWorld = mul(unity_ObjectToWorld, vertex);
                vertex += (_CentrePoint-castToWorld)*-(_SizeDifference * time) * _Hover;
                return vertex;
            }

            v2f vert (appdata v)
            {
                v2f o;
                
                    v.vertex = IncreaseSize(v.vertex);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
