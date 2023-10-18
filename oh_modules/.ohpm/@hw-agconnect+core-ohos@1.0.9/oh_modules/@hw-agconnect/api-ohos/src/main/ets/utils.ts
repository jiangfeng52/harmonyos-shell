export function defineProperty(target: unknown, property: unknown): unknown {

  if (!(property instanceof Object)) {
    return property;
  }

  switch (property.constructor) {
    case Array:
      target = [];
      break;

    case Object:
      if (target === undefined) {
        target = {};
      }
      break;

    case Date:
      const dateValue = property as Date;
      return new Date(dateValue.getTime());

    default:
      return property;
  }

  for (const prop in property) {
    if (!property.hasOwnProperty(prop)) {
      continue;
    }
    (target as { [key: string]: unknown })[prop] = defineProperty(
      (target as { [key: string]: unknown })[prop],
      (property as { [key: string]: unknown })[prop]
    );
  }

  return target;
}
