#version 120

attribute vec3 vPosition;
attribute vec3 vNormal, vNormal2;
attribute vec2 vTexCoord;

varying vec3 vNorm, vNorm2;

varying vec3 normal;

varying vec2 texCoord;
varying vec4 color;

varying vec3 position, position2;

varying vec3 pos, Lvec, Lvec2;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct, AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition, LightPosition2;
uniform float Shininess;

// part 2. Animations
attribute vec4 boneIDs;
attribute vec4 boneWeights;
uniform mat4 boneTransforms[64];

void main()
{
    // Part 2. [A]
    ivec4 bone = ivec4(boneIDs); // convert boneIDs to ivec4
    mat4 boneTransform = boneWeights[0] * boneTransforms[bone[0]] + 
 				boneWeights[1] * boneTransforms[bone[1]] +
				boneWeights[2] * boneTransforms[bone[2]] +
				boneWeights[3] * boneTransforms[bone[3]];

    vec4 vpos = boneTransform * vec4(vPosition, 1.0); 

    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    Lvec = LightPosition.xyz - pos;
    position = pos;
    Lvec2 = LightPosition2.xyz; // part I. directional

    vNorm = mat3(boneTransform) * vNormal; vNorm2 = mat3(boneTransform) * vNormal2; // parse vNormal to fStart


    /*  *********************************************************************************************************************  */
    /* COMMENT OUT ALL LIGHTING CALCULATIONS - MOVE THEM TO THE FRAGMENT SHADER */
    // Unit direction vectors for Blinn-Phong shading calculation
    //fL = normalize( Lvec );   // Direction to the light source
    //fE = normalize( -pos );   // Direction to the eye/camera
    //fH = normalize( fL + fE );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    //fN = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    //vec3 ambient = AmbientProduct;

    //float Kd = max( dot(L, N), 0.0 );
    //vec3  diffuse = Kd * DiffuseProduct;

    //float Ks = pow( max(dot(N, H), 0.0), Shininess );
    //vec3  specular = Ks * SpecularProduct;
    
    //if (dot(L, N) < 0.0 ) {
	//specular = vec3(0.0, 0.0, 0.0);
    //} 

    // Part F.
    /* calculate an appropriate attenuation based on the distance of light source */
    //float lenVec = length(Lvec); 
    //float a = 1.0; // weight
    //float b = 1.0; // weight
    // calculate attenuation
    //float att = 1.0 / (1.0 + a*lenVec + b*lenVec*lenVec);

    // globalAmbient is independent of distance from the light source
    //vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    // [F.] globalAmbient and ambient do NOT depend on distance thus the attenuation (att) should only affect diffuse and specular
    //color.rgb = globalAmbient  + ambient + att*(diffuse + specular);
    //color.a = 1.0;
    /* ***************************************************************************************************  */


    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}

