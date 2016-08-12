function field = keyGenerator(entity, class)

geneartor = str2func(['@(entity)' class '.generate(entity)']);
field = geneartor(entity);
end

