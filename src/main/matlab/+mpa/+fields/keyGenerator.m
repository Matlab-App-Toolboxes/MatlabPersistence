function field = keyGenerator(entity, id)

geneartor = str2func(['@(entity, name)' id.field '.generate(entity, name)']);
field = geneartor(entity, id.name);
end

