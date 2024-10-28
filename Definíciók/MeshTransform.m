classdef MeshTransform < handle
    % MESHTRANSFORM Data type to represent a 3D transformation.
    properties (SetAccess = private)
        m (4,4) double % Internal matrix
    end
    
    methods
        function t = MeshTransform()
            % MESHTRANSFORM Create new identity transformation.
            %
            %   t = MESHTRANSFORM()
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Identity transformation
            %
            %   See also MESHOBJECT, MESHVECTOR
            t.m = eye(4);
        end
        function t = inv(self)
            % INV Return inverse transformation.
            %
            %   t = MESHTRANSFORM.INV(self)
            %
            %   Args:
            %   - self (1,1) MeshTransform: Transformation instance to operate on
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Inverse transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                self (1,1) MeshTransform
            end
            t = MeshTransform();
            t.m = pinv(self.m);
        end
        function t = plus(t1,t2)
            % PLUS Combine transformations.
            %   (Overloads the + operator)
            %
            %   t = MESHTRANSFORM.PLUS(t1,t2)
            %
            %   Args:
            %   - t1 (1,1) MeshTransform: Transformation to add to
            %   - t2 (1,1) MeshTransform: Transformation to add
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Combined transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                t1 (1,1) MeshTransform
                t2 (1,1) MeshTransform
            end
            t = MeshTransform();
            t.m = t1.m * t2.m;
        end
        function t = minus(t1,t2)
            % MINUS Remove transformation.
            %   (Overloads the - operator)
            %
            %   t = MESHTRANSFORM.MINUS(t1,t2)
            %
            %   Args:
            %   - t1 (1,1) MeshTransform: Transformation to remove from
            %   - t2 (1,1) MeshTransform: Transformation to remove
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Combined transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                t1 (1,1) MeshTransform
                t2 (1,1) MeshTransform
            end
            t = t1 + t2.inv();
        end
        function t = uplus(self)
            % UPLUS Return a copy of the transformation.
            %   (Overloads the unary + operator)
            %
            %   t = MESHTRANSFORM.UPLUS(self)
            %
            %   Args:
            %   - self (1,1) MeshTransform: Transformation instance to operate on
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Copy of transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                self (1,1) MeshTransform
            end
            t = MeshTransform();
            t.m = self.m;
        end
        function t = uminus(self)
            % UMINUS Return inverse transformation.
            %   (Overloads the unary - operator)
            %
            %   t = MESHTRANSFORM.UMINUS(self)
            %
            %   Args:
            %   - self (1,1) MeshTransform: Transformation instance to operate on
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Inverse transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                self (1,1) MeshTransform
            end
            t = self.inv();
        end
    end
    
    methods (Static)
        function t = translate(offset)
            % TRANSLATE Create new translation transformation.
            %
            %   t = MESHTRANSFORM.TRANSLATE(offset)
            %
            %   Args:
            %   - offset (1,1) MeshVector: Translation offset
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Translation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                offset (1,1) MeshVector
            end
            t = MeshTransform();
            t.m(1:3,4) = offset.coords';
        end
        function t = scale(factors)
            % SCALE Create new scaling transformation.
            %
            %   t = MESHTRANSFORM.SCALE(factors)
            %
            %   Args:
            %   - factors (1,3) double: Scaling x,y,z components
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Scaling transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                factors (1,3) double
            end
            t = MeshTransform();
            t.m = diag([factors,1]);
        end
        function t = scaleuniform(factor)
            % SCALEUNIFORM Create new uniform scaling transformation.
            %
            %   t = MESHTRANSFORM.SCALEUNIFORM(factor)
            %
            %   Args:
            %   - factor (1,1) double: Scaling factor
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Uniform scaling transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                factor (1,1) double
            end
            t = MeshTransform.scale([factor, factor, factor]);
        end
        function t = rotationX(angle)
            % ROTATIONX Create new rotation transformation along X axis.
            %
            %   t = MESHTRANSFORM.ROTATIONX(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in radians
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform();
            t.m = [
                [1, 0, 0, 0];
                [0, cos(angle), -sin(angle), 0];
                [0, sin(angle), cos(angle), 0];
                [0, 0, 0, 1]
            ];
        end
        function t = rotationY(angle)
            % ROTATIONY Create new rotation transformation along Y axis.
            %
            %   t = MESHTRANSFORM.ROTATIONY(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in radians
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform();
            t.m = [
                [cos(angle), 0, sin(angle), 0];
                [0, 1, 0, 0];
                [-sin(angle), 0, cos(angle), 0];
                [0, 0, 0, 1]
            ];
        end
        function t = rotationZ(angle)
            % ROTATIONZ Create new rotation transformation along Z axis.
            %
            %   t = MESHTRANSFORM.ROTATIONZ(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in radians
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform();
            t.m = [
                [cos(angle), -sin(angle), 0, 0];
                [sin(angle), cos(angle), 0 ,0];
                [0, 0, 1, 0];
                [0, 0, 0, 1]
            ];
        end
        function t = drotationX(angle)
            % DROTATIONX Create new rotation transformation along X axis.
            %
            %   t = MESHTRANSFORM.DROTATIONX(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in degrees
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform.rotationX(angle / 180 * pi);
        end
        function t = drotationY(angle)
            % DROTATIONY Create new rotation transformation along Y axis.
            %
            %   t = MESHTRANSFORM.DROTATIONY(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in degrees
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform.rotationY(angle / 180 * pi);
        end
        function t = drotationZ(angle)
            % DROTATIONZ Create new rotation transformation along Z axis.
            %
            %   t = MESHTRANSFORM.DROTATIONZ(angle)
            %
            %   Args:
            %   - angle (1,1) double: Rotation angle in degrees
            %
            %   Returns:
            %   - t (1,1) MeshTransform: Rotation transformation
            %
            %   See also MESHTRANSFORM, MESHOBJECT, MESHVECTOR
            arguments
                angle (1,1) double
            end
            t = MeshTransform.rotationZ(angle / 180 * pi);
        end
    end
end
