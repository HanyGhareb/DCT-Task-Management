"""Reconnect only at worker boundaries; never replay writes or queue claims."""
import random
import time


def disconnected(error):
    detail = error.args[0] if error.args else error
    code = getattr(detail, 'full_code', '') or str(detail).split(':', 1)[0]
    return code in {'DPY-4011', 'DPY-1001', 'ORA-03113', 'ORA-03114',
                    'ORA-03135', 'ORA-01012', 'ORA-12537', 'ORA-12541',
                    'ORA-12545', 'ORA-12170', 'DPY-6005'}


def ensure_connection(conn, connect, sleep=time.sleep, log=print):
    """Idle-boundary ping/reconnect; caller must rebuild connection closures.

    Non-connectivity errors fail normally. Only safe ping/connect operations
    are retried, with capped backoff and jitter to spread fleet reconnections.
    No reference to the browser or Fusion auth state is touched.
    """
    delay = 5
    while True:
        try:
            if conn is None:
                conn = connect()
            conn.ping()
            return conn
        except Exception as error:
            if not disconnected(error):
                raise
            if conn is not None:
                try:
                    conn.close()
                except Exception:
                    pass
            conn = None
            log(f'[db-recovery] connection unavailable; retry in {delay}s', flush=True)
            sleep(delay + random.uniform(0, 2))
            delay = min(delay * 2, 60)
