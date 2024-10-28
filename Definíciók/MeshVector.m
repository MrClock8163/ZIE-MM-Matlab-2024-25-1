classdef MeshVector
    % MESHVECTOR 3D vector for use in meshes.
    properties (SetAccess = private)
        x (1,1) double = 0 % X coordinate component
        y (1,1) double = 0 % Y coordinate component
        z (1,1) double = 0 % Z coordinate component
    end
    
    properties (Dependent)
        coords (1,3) double % Read-only access to coordinates as array
    end
    
    methods
        function obj = MeshVector(components)
            % MESHVECTOR Initialize new vector from components.
            %   
            %   vec = MESHVECTOR(components)
            %
            %   Args:
            %   - components (1,3) double: X, Y and Z oordinate components
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Vector initialized with given inputs
            %
            %   See also MESHTRIANGLE, MESHOBJECT
            arguments
                components (1,3) double
            end
            obj.x = components(1);
            obj.y = components(2);
            obj.z = components(3);
        end
        function vec = get.coords(self)
            % GET.COORDS Getter method of the read-only coords property.
            vec = [self.x,self.y,self.z];
        end
        function vec = plus(vec1,vec2)
            % PLUS Sum of two MeshVectors.
            %   (Overloads the + operator)
            %   
            %   vec = MESHVECTOR.PLUS(vec1, vec2)
            %
            %   Args:
            %   - vec1 (1,1) MeshVector: Vector to add to
            %   - vec2 (1,1) MeshVector: Vector to add
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Sum of the input vectors
            %
            %   See also MESHVECTOR, PLUS
            arguments
                vec1 MeshVector
                vec2 MeshVector
            end
            vec = MeshVector(vec1.coords + vec2.coords);
        end
        function obj = minus(var1,var2)
            % MINUS Difference of two MeshVectors.
            %   (Overloads the - operator)
            %   
            %   vec = MESHVECTOR.MINUS(vec1, vec2)
            %
            %   Args:
            %   - vec1 (1,1) MeshVector: Vector to substract from
            %   - vec2 (1,1) MeshVector: Vector to substract
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Difference of the input vectors
            %
            %   See also MESHVECTOR, MINUS
            arguments
                var1 MeshVector
                var2 MeshVector
            end
            obj = MeshVector(var1.coords - var2.coords);
        end
        function vec = times(vecin,scale)
            % TIMES Scale vector by scalar.
            %   (Overloads the .* operator)
            %   
            %   vec = MESHVECTOR.TIMES(vecin, scale)
            %
            %   Args:
            %   - vecin (1,1) MeshVector: Vector to scale
            %   - scale (1,1) double: Scaling factor
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Scaled vector
            %
            %   See also MESHVECTOR, TIMES
            arguments
               vecin MeshVector
               scale (1,1) double
            end
            vec = MeshVector(vecin.coords * scale);
        end
        function vec = uminus(self)
            % UMINUS Negate vector components.
            %   (Overloads the unary - operator)
            %   
            %   vec = MESHVECTOR.UMINUS(self)
            %
            %   Args:
            %   - self (1,1) MeshVector: Vector instance to operate on
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Negated vector
            %
            %   See also MESHVECTOR, UMINUS
            vec = MeshVector(self.coords * -1);
        end
        function obj = uplus(self)
            % UPLUS Returns copy of vector.
            %   (Overloads the unary + operator)
            %   
            %   vec = MESHVECTOR.UPLUS(self)
            %
            %   Args:
            %   - self (1,1) MeshVector: Vector instance to operate on
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Copy of vector
            %
            %   See also MESHVECTOR, UPLUS
            obj = self;
        end
        function prod = dot(vec1, vec2)
            % DOT Calculate dot product of vectors.
            %   
            %   prod = MESHVECTOR.DOT(vec1, vec2)
            %
            %   Args:
            %   - vec1 (1,1) MeshVector: 3D vector
            %   - vec2 (1,1) MeshVector: 3D vector
            %
            %   Returns:
            %   - prod (1,1) double: Dot product of input vectors
            %
            %   See also MESHVECTOR, DOT
            arguments
                vec1 (1,1) MeshVector
                vec2 (1,1) MeshVector
            end
            prod = dot(vec1.coords, vec2.coords);
        end
        function vec = cross(vec1, vec2)
            % CROSS Calculate cross product of vectors.
            %   
            %   vec = MESHVECTOR.CROSS(vec1, vec2)
            %
            %   Args:
            %   - vec1 (1,1) MeshVector: 3D vector
            %   - vec2 (1,1) MeshVector: 3D vector
            %
            %   Returns:
            %   - vec (1,1) MeshVector: Cross product of input vectors
            %
            %   See also MESHVECTOR, CROSS
            arguments
                vec1 (1,1) MeshVector
                vec2 (1,1) MeshVector
            end
            vec = MeshVector(cross(vec1.coords, vec2.coords));
        end
        function prod = len(self)
            % LEN Length of 3D vector.
            %   
            %   prod = MESHVECTOR.LEN(self)
            %
            %   Args:
            %   - self (1,1) MeshVector: Vector instance to operate on
            %
            %   Returns:
            %   - prod (1,1) double: Length of input vector
            %
            %   See also MESHVECTOR
            prod = sqrt(sum(self.coords.^2));
        end
    end
end

