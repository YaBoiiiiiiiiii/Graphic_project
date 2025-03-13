//CODE BASÉ SUR : https://www.processing.org/tutorials/pshader/

uniform mat4 transformMatrix;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying float z;

void main() {
  gl_Position = transformMatrix * position;
  z = position.z;
  
  vertColor = color;
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
