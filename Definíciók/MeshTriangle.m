classdef MeshTriangle
    % MESHTRIANGLE Triangular face constructed from 3 vertices.
    properties (SetAccess = private)
        verts (1,3) MeshVector = MeshVector([0,0,0]) % Triangle vertices
    end
    
    methods
        function tri = MeshTriangle(vertices)
            % MESHTRIANGLE Initialize new triangle from given 3 vectors.
            %   
            %   tri = MESHTRIANGLE(verts)
            %
            %   Args:
            %   - verts (1,3) MeshVector: List of vertices
            %
            %   Returns:
            %   - tri (1,1) MeshTriangle: Triangle initialized with given inputs
            %
            %   See also MESHVECTOR, MESHOBJECT
            arguments
               vertices (1,3) MeshVector 
            end
            tri.verts = vertices;
        end
        function ar = area(self)
            % AREA Calculate area of triangle.
            %   The face area is calculated with Heron's formula.
            %   
            %   a = MESHTRIANGLE.AREA(self)
            %
            %   Args:
            %   - self (1,1) MeshTriangle: Triangle instance to operate on
            %
            %   Returns:
            %   - a (1,1) double: Triangle area
            %
            %   See also MESHVECTOR, MESHOBJECT
            a = len(self.verts(2) - self.verts(3));
            b = len(self.verts(1) - self.verts(3));
            c = len(self.verts(2) - self.verts(1));
            s = (a + b + c) / 2;
            
            ar = sqrt(s * (s-a) * (s-b) * (s-c));
        end
    end
end

