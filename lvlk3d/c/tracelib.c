#include <stdio.h>
#include <stdbool.h>
#include <math.h>

#define MAX_MODELS 4096
#define MAX_VERTS 2097152
#define MAX_FACES 1048576


#define DBL_EPSILON 2.2204460492503131e-16

typedef struct Vector {
    float x;
    float y;
    float z;
} Vector;

typedef struct TraceResult {
    bool hit;
	float dist;
    Vector pos;
} TraceResult;

typedef struct UV {
	float u;
	float v;
} UV;

typedef struct Face {
	Vector normal;
	unsigned long long v1i;
	unsigned long long v2i;
	unsigned long long v3i;

	unsigned long long v1ui;
	unsigned long long v2ui;
	unsigned long long v3ui;
} Face;

// later later
typedef struct Model {
	unsigned long long vertCount;
	unsigned long long faceCount;

	Vector vertList[MAX_VERTS];
	Face faceList[MAX_FACES];

} Model;


typedef struct LvLK3DModelData {
	Vector verts[MAX_VERTS];
	Vector normals[MAX_VERTS];
	UV uvs[MAX_VERTS];
	Face faceInd[MAX_FACES];
} LvLK3DModelData;


Model mdlList[MAX_MODELS];


/*
unsigned int declare_model(unsigned int index, unsigned long long vertCount, unsigned long long faceCount, Vector vertList[MAX_VERTS]) {
	Model newMdl;
	newMdl.vertCount = vertCount;
	newMdl.faceCount = faceCount;

	mdlList[index] = 
};
*/


void vector_copy(Vector* result, Vector* const cpy) {
	(*result).x = cpy->x;
	(*result).y = cpy->y;
	(*result).z = cpy->z;
};


void vector_sub(Vector* vec1, Vector* const vec2) {
    (*vec1).x = vec1->x - vec2->x;
    (*vec1).y = vec1->y - vec2->y;
    (*vec1).z = vec1->z - vec2->z;
};

void vector_add(Vector* vec1, Vector* const vec2) {
    (*vec1).x = vec1->x + vec2->x;
    (*vec1).y = vec1->y + vec2->y;
    (*vec1).z = vec1->z + vec2->z;
};

void vector_neg(Vector* vec) {
	(*vec).x = -vec->x;
	(*vec).y = -vec->y;
	(*vec).z = -vec->z;
}

void vector_neg_r(Vector* out, Vector* const vec) {
	(*out).x = -vec->x;
	(*out).y = -vec->y;
	(*out).z = -vec->z;
}

void vector_mul_f(Vector* vec1, float s) {
    (*vec1).x = vec1->x * s;
    (*vec1).y = vec1->y * s;
    (*vec1).z = vec1->z * s;
};

void vector_sub_r(Vector* result, Vector* const vec1, Vector* const vec2) {
    (*result).x = vec1->x - vec2->x;
    (*result).y = vec1->y - vec2->y;
    (*result).z = vec1->z - vec2->z;
};

void vector_add_r(Vector* result, Vector* const vec1, Vector* const vec2) {
    (*result).x = vec1->x + vec2->x;
    (*result).y = vec1->y + vec2->y;
    (*result).z = vec1->z + vec2->z;
};


void vector_cross(Vector* result, Vector* const vec1, Vector* const vec2) {
    (*result).x = vec1->y * vec2->z - vec1->z * vec2->y;
    (*result).y = vec1->z * vec2->x - vec1->x * vec2->z;
    (*result).z = vec1->x * vec2->y - vec1->y * vec2->x;
};

float vector_dot(Vector* const vec1, Vector* const vec2) {
    return vec1->x * vec2->x + vec1->y * vec2->y + vec1->z * vec2->z;
};

void vector_print(Vector* const vec) {
	printf("Vector(%.2f, %.2f, %.2f)", vec->x, vec->y, vec->z);
};

// https://github.com/excessive/cpml/blob/master/modules/intersect.lua
TraceResult rayIntersectsTriangle(Vector rayPos, Vector rayDir, Vector v1, Vector v2, Vector v3, bool backface_cull) {
	//vector_neg(&v1);
	//vector_neg(&v2);
	//vector_neg(&v3);


    Vector e1;
	vector_sub_r(&e1, &v2, &v1);
    //Vector e2 = vector_sub(v3, v1)

	Vector e2;
	vector_sub_r(&e2, &v3, &v1);

	Vector h;
	vector_cross(&h, &rayDir, &e2);


	float a = vector_dot(&h, &e1);

	// if a is negative, ray hits the backface
	if(backface_cull && a < 0) {
		TraceResult out;
		out.hit = false;
		return out;
	};

	// if a is too close to 0, ray does not intersect triangle
	if(fabs(a) <= DBL_EPSILON) {
		TraceResult out;
		out.hit = false;
		return out;
	}

	float f = 1.0f / a;

	Vector s;
	vector_sub_r(&s, &rayPos, &v1);

	float u = vector_dot(&s, &h) * f;

	// ray does not intersect triangle
	if(u < 0.0f || u > 1.0f) {
		TraceResult out;
		out.hit = false;
		return out;
	}

	Vector q;
	vector_cross(&q, &s, &e1);

	float v = vector_dot(&rayDir, &q) * f;

	// ray does not intersect triangle
	if(v < 0.0f || u + v > 1.0f) {
		TraceResult out;
		out.hit = false;
		return out;
	}

	// at this stage we can compute t to find out where
	// the intersection point is on the line
	float t = vector_dot(&q, &e2) * f;

	// return position of intersection and distance from ray origin
	if(t >= DBL_EPSILON) {
		TraceResult out;

		Vector hp;
		vector_copy(&hp, &rayDir);
		vector_mul_f(&hp, t); // rayDir * t
		vector_add(&hp, &rayPos);

		//vector_neg(&hp);
		out.pos = hp;
		out.dist = t;
		out.hit = true;

		return out;
	}

	TraceResult out;
	out.hit = false;

	return out;
}