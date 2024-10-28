classdef MeshObject
    % MESHOBJECT Data type to contain and operate on simple mesh data.
    %    The mesh is made up of verticies and faces.
    properties (SetAccess = private)
        verts (1,:) MeshVector = MeshVector.empty % Mesh vertices
        faces (1,:) MeshTriangle = MeshTriangle.empty % Mesh faces
    end
    
    methods
        function obj = MeshObject(verts, faces)
            % MESHOBJECT Initialize new object from a list of vertices and triangular faces.
            %   
            %   mesh = MESHOBJECT(verts, faces)
            %
            %   Args:
            %   - verts (1,:) MeshVector: List of vertices
            %   - faces (1,:) MeshTriangle: List of faces
            %
            %   Returns:
            %   - mesh (1,1) MeshObject: Mesh initialized with given inputs
            %
            %   See also MESHVECTOR, MESHTRIANGLE
            arguments
                verts (1,:) MeshVector
                faces (1,:) MeshTriangle
            end
            obj.verts = verts;
            obj.faces = faces;
        end
        function a = area(self)
            % AREA Calculate mesh surface area by the sum of triangle areas.
            %
            %   a = MESHOBJECT.AREA(self)
            %
            %   Args:
            %   - self (1,1) MeshObject: Object instance to operate on
            %
            %   Returns:
            %   - a (1,1) double: Surface area of MESHOBJECT
            %
            %   See also MESHOBJECT
            a = 0;
            for f = self.faces
                a = a + f.area();
            end
        end
        function v = volume(self)
            % VOLUME Calculate volume of closed mesh.
            %   The volume is calculated as the signed sum of tetrahedrons
            %   constructed from the individual triangle faces and the
            %   origin point.
            %
            %   a = MESHOBJECT.VOLUME(self)
            %
            %   Args:
            %   - self (1,1) MeshObject: Object instance to operate on
            %
            %   Returns:
            %   - a (1,1) double: Volume of MESHOBJECT
            %
            %   See also MESHOBJECT
            v = 0;
            for f = self.faces
                v1 = f.verts(1);
                v2 = f.verts(2);
                v3 = f.verts(3);
                v = v + v1.dot(v2.cross(v3)) / 6;
            end
        end
        function transform(self,mat)
            % TRANSFORM Apply 3D transformation to model.
            %
            %   MESHOBJECT.TRANSFORM(self,mat)
            %
            %   Args:
            %   - self (1,1) MeshObject: Object instance to operate on
            %   - mat (1,1) MeshTransform: Transformation to apply
            %
            %   See also MESHOBJECT, MESHTRANSFORM, MESHVECTOR.TRANSFORM
            arguments
                self (1,1) MeshObject
                mat (1,1) MeshTransform
            end
            for v = self.verts
                v.transform(mat);
            end
        end
    end
    
    methods (Static)
        function obj = readOBJ(filepath)
            % READOBJ Read simple OBJ file data from the specified path, and construct new MeshObject with it.
            %   The OBJ must be ASCII type and contain only triangles, and only vertex and face
            %   data. The method cannot handle UV coordinates, vertex normals
            %   or other face related extra data.
            %
            %   mesh = MESHOBJECT.READOBJ(filepath)
            %
            %   Args:
            %   - filepath (1,1) string: Path to OBJ file
            %
            %   Returns:
            %   - mesh (1,1) MeshObject
            %
            %   See also FOPEN, MESHOBJECT.JUMPTOBLOCK, MESHVECTOR, MESHTRIANGLE
            arguments
                filepath (1,1) string
            end
            ptr = fopen(filepath);
            if ~MeshObject.jumpToBlock(ptr, 'v')
                fclose(ptr);
                obj = [];
                return
            end
            vert_coords = cell2mat(textscan(ptr, 'v %f %f %f'));
            
            if ~MeshObject.jumpToBlock(ptr, 'f')
                fclose(ptr);
                obj = [];
                return
            end
            vert_indices = cell2mat(textscan(ptr, 'f %d %d %d'));
            fclose(ptr);
            
            verts = MeshVector.empty;
            for i = 1:size(vert_coords,1)
                verts(end+1) = MeshVector(vert_coords(i,:));
            end
            
            faces = MeshTriangle.empty;
            for i = 1:size(vert_indices,1)
                v1 = verts(vert_indices(i,1));
                v2 = verts(vert_indices(i,2));
                v3 = verts(vert_indices(i,3));
                
                faces(end+1) = MeshTriangle([v1,v2,v3]);
            end
            obj = MeshObject(verts, faces);
        end
    end
    methods (Static, Access = private) 
        function success = jumpToBlock(ptr, id)
            % JUMPTOBLOCK In an open ASCII OBJ file jump to the first line with the
            %   given type code.
            %
            %   success = MESHOBJECT.JUMPTOBLOCK(ptr, id)
            %
            %   Args:
            %   - ptr (1,1) double: Pointer to opened OBJ file
            %   - id (1,1) char: Data type to jump to (eg.: 'v' for verts)
            %
            %   Returns:
            %   - success (1,1) logical: True if the data type was found
            %
            %   See also FOPEN, FSEEK, FTELL, MESHOBJECT.READOBJ
            arguments
                ptr (1,1) double
                id (1,1) char
            end
            fseek(ptr, 0, 'bof');
            while ~feof(ptr)
                pos = ftell(ptr);
                l = fgetl(ptr);
                if startsWith(l,id)
                    fseek(ptr, pos, 'bof');
                    success = true;
                    return
                end
            end
            success = false;
        end
    end
end

