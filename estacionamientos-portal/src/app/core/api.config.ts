const LOCAL_BACKEND_PORT = '8000';
const RAILWAY_BACKEND_HOST = 'smartparking-production-9a89.up.railway.app';

const isPrivateNetworkHost = (hostname: string): boolean =>
  hostname === 'localhost' ||
  hostname === '127.0.0.1' ||
  hostname === '0.0.0.0' ||
  hostname.startsWith('192.168.') ||
  hostname.startsWith('10.') ||
  /^172\.(1[6-9]|2\d|3[01])\./.test(hostname);

const buildApiConfig = () => {
  const hostname = typeof window !== 'undefined' ? window.location.hostname : '';

  if (isPrivateNetworkHost(hostname)) {
    const localHost = hostname === '0.0.0.0' ? 'localhost' : hostname;

    return {
      baseUrl: `http://${localHost}:${LOCAL_BACKEND_PORT}`,
      parkingSocketUrl: `ws://${localHost}:${LOCAL_BACKEND_PORT}/ws/parking`,
    };
  }

  return {
    baseUrl: `https://${RAILWAY_BACKEND_HOST}`,
    parkingSocketUrl: `wss://${RAILWAY_BACKEND_HOST}/ws/parking`,
  };
};

export const API_CONFIG = buildApiConfig();
