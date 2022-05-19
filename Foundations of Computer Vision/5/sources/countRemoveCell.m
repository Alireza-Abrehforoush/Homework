function J = countRemoveCell(i, j, I, id)
%COUNTREMOVECELL Summary of this function goes here
%   Detailed explanation goes her
    J = I;
    if (J(i, j) == 1)
        J(i, j) = 0;
        if (i - 1 >= 1)
            J = countRemoveCell(i - 1, j, J, id);
            if (j - 1 >= 1)
                J = countRemoveCell(i - 1, j - 1, J, id);
                J = countRemoveCell(i, j - 1, J, id);
            end
            if (j + 1 <= size(I, 2))
                J = countRemoveCell(i - 1, j + 1, J, id);
                J = countRemoveCell(i, j + 1, J, id);
            end
        end
        if (i + 1 <= size(I, 1))
            J = countRemoveCell(i + 1, j, J, id);
            if (j - 1 >= 1)
                J = countRemoveCell(i + 1, j - 1, J, id);
            end
            if (j + 1 <= size(I, 2))
                J = countRemoveCell(i + 1, j + 1, J, id);
            end
        end
    end
end

