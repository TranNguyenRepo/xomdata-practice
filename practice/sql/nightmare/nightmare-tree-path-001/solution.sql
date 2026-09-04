-- Xom Data · Root path plus subtree sum per node
-- Problem: https://xomdata.com/practice/nightmare-tree-path-001
-- Solved: 2026-09-04

WITH RECURSIVE tree as
(SELECT
    id as ancestor, 
    name as ancestor_name, 
    id as descendant,
    name as descendant_name
    -- 0 as depth,
    -- name as path
    
FROM nodes 

UNION ALL
SELECT 
    t.ancestor, 
    t.ancestor_name,
    n.id,
    n.name
    -- depth + 1,
    -- path || '>' || n.name
FROM tree t
JOIN nodes n
ON t.descendant = n.parent_id
)
, subtree as
(SELECT *, count(descendant) as subtree_size FROM tree
GROUP BY ancestor
ORDER BY ancestor_name)
, 
path as
(
    SELECT 
        id as id, 
        name as name, 
        name as path,
        0 as depth
    FROM nodes
    WHERE parent_id is null

    UNION ALL
    SELECT
        n.id,
        n.name,
        path || ' > ' || n.name,
        depth + 1
    FROM path
    JOIN nodes n
    ON n.parent_id = path.id
)
, adding_budget as
(SELECT path.id, path.name, path.depth, path.path, tree.*, n.budget  FROM path
JOIN tree
ON tree.ancestor = path.id
JOIN nodes n
ON tree.descendant = n.id)
SELECT id, name, depth, path, subtree.subtree_size, sum(budget) as subtree_budget 
FROM adding_budget
JOIN subtree
ON subtree.ancestor = adding_budget.id
GROUP BY id
ORDER BY depth, id asc;
