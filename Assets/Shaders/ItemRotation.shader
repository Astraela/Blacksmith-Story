Shader "ISA/ItemRotation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PositionSpeed ("Vertical speed", float) = 1
        _RotationSpeed ("Rotation speed", float) = 1
        _PositionMin ("Position Minimum", float) = 0
        _PositionMax ("Position Maximum", float) = 3
        _SizeDecrease ("Size Decrease", float) = 0
        _Axis ("Axis", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "DisableBatching"="True" }
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
                float4 uv : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _PositionSpeed;
            float _RotationSpeed;
            float _PositionMin;
            float _PositionMax;
            float _SizeDecrease;
            float _Axis;
            
            float4 RotateAroundYInDegrees (appdata v, float degrees)
            {
                //turn degrees into radians
                float radians = degrees * UNITY_PI / 180.0;

                float sina, cosa;
                //Sets the value of sinus and the cosinus (sina,cosa)
                sincos(radians, sina, cosa);
                //Creates a 2x2 matrix
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                //Applies the 2x2 matrix on the y axis, add the yw of the vertex
                v.vertex = float4(mul(m, v.vertex.xz), v.vertex.yw).xzyw;
                return v.vertex;
            }

            float4 RotateAroundZInDegrees (appdata v, float degrees)
            {
                //turn degrees into radians
                float radians = degrees * UNITY_PI / 180.0;

                float sina, cosa;
                //Sets the value of sinus and the cosinus (sina,cosa)
                sincos(radians, sina, cosa);
                //Creates a 2x2 matrix
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                //Applies the 2x2 matrix on the y axis, add the yw of the vertex
                v.vertex = float4(mul(m, v.vertex.xy), v.vertex.zw).xyzw;
                return v.vertex;
            }

            float4 RotateAroundXInDegrees (appdata v, float degrees)
            {
                //turn degrees into radians
                float radians = degrees * UNITY_PI / 180.0;

                float sina, cosa;
                //Sets the value of sinus and the cosinus (sina,cosa)
                sincos(radians, sina, cosa);
                //Creates a 2x2 matrix
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                //Applies the 2x2 matrix on the y axis, add the yw of the vertex
                v.vertex = float4(v.vertex.x, mul(m, v.vertex.yz), v.vertex.w).xyzw;
                return v.vertex;
            }

            float4 DecreaseSize (float4 vertex){
                float4 objectOrigin = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0) );
                float4 castToWorld = mul(unity_ObjectToWorld, vertex);
                vertex -= (objectOrigin-castToWorld)*-_SizeDecrease;
                return vertex;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = DecreaseSize(o.vertex);
                
                float4 objectOrigin = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0) );
                float4 castToWorld = mul(unity_ObjectToWorld, v.vertex);
                if(_Axis == 1){
                    v.vertex = RotateAroundYInDegrees(v,_Time.w * _RotationSpeed);
                }else if(_Axis == 2){
                    v.vertex = RotateAroundZInDegrees(v,_Time.w * _RotationSpeed);
                }else if(_Axis == 0){
                    v.vertex = RotateAroundXInDegrees(v,_Time.w * _RotationSpeed);
                }
                o.vertex = UnityObjectToClipPos(v.vertex);//+(centerPos-cornerPos);
                
                //First we do 1+sintime to get a range of 0-2, we divide that by 2 so its 0-1, times the difference in max&min results in a range between, add min to that and perfection :)
                o.vertex.y += _PositionMin + ((1 + sin(_Time*_PositionSpeed))/2* (_PositionMax-_PositionMin));
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
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
