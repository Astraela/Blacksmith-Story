Shader "ISA/Hologram"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Multiplier ("Speed Multiplier",float) = 1
        _Min ("Min",float) = 0
        _Max ("Max",float) = 1
        _Tone ("Tone", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
            #pragma vertex vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _Multiplier;
        float _Min;
        float _Max;
        fixed4 _Tone;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };
        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float4 color : COLOR;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
            float4 texcoord3 : TEXCOORD3;
            uint instanceId : SV_InstanceID;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata v)
        {
            float t = 1- (_Time.x*_Multiplier)%1;
            t = _Min + (_Max-_Min)*t;
            float step = .1;
                float4 objectOrigin = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0) );
            float3 castToWorld = mul(unity_ObjectToWorld, v.vertex);
            if (castToWorld.y > t-step && castToWorld.y < t+step) {
                //v.vertex.x += 1;
                v.vertex.x +=  (castToWorld.x-objectOrigin.x);
            }
            
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color


            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            
            float t = 1- (_Time.x*_Multiplier)%1;
            t = _Min + (_Max-_Min)*t;
            float step = .1;
            if (IN.worldPos.y > t-step && IN.worldPos.y < t+step) {
                c.r = _Tone.r*_Tone.a + c.r*(1-_Tone.a);
                c.g = _Tone.g*_Tone.a + c.g*(1-_Tone.a);
                c.b = _Tone.b*_Tone.a + c.b*(1-_Tone.a);
            }

                o.Albedo = c.rgb;

            
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
