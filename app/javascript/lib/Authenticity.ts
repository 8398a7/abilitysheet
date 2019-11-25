export const authenticityHeaders = (
  otherHeaders: { [id: string]: string } = {},
) => {
  return Object.assign(otherHeaders, {
    'X-CSRF-Token': authenticityToken(),
    'X-Requested-With': 'XMLHttpRequest',
  });
};

const authenticityToken = () => {
  const token = document.querySelector<HTMLMetaElement>(
    'meta[name="csrf-token"]',
  );
  if (token) {
    return token.content;
  }
  return null;
};
