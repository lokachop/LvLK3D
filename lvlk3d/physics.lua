LvLK3D = LvLK3D or {}
local ffi = require("ffi")

-- ode might be viable?
local physlib = ffi.load("lvlk3d/ffi/libode-8.dll")

ffi.cdef([[
    typedef double dReal;

    struct dxWorld;     /* dynamics world */
    struct dxSpace;     /* collision space */
    struct dxBody;      /* rigid body (dynamics object) */
    struct dxGeom;      /* geometry (collision object) */
    struct dxJoint;     /* joint */
    struct dxJointGroup;/* joint group */
    

    typedef struct dxWorld {
        int _dummy;
    };
    typedef struct dxSpace {
        int _dummy;
    };
    typedef struct dxBody {
        int _dummy;
    };
    typedef struct dxGeom {
        int _dummy;
    };
    typedef struct dxJoint {
        int _dummy;
    };
    typedef struct dxJointGroup {
        int _dummy;
    };
    typedef struct dxTriMeshData {
        int _dummy;
    };
    typedef struct dxHeightfieldData {
        int _dummy;
    };

    struct MyObject {
        dBodyID body;			// the body
        dGeomID geom[3];		// geometries representing this body
    };

    struct MyFeedback {
        dJointFeedback fb;
        bool first;
    };
]])
