import unittest
from unittest.mock import Mock
import db_recovery


class RecoveryTests(unittest.TestCase):
    def test_healthy_connection_is_preserved(self):
        conn, connect = Mock(), Mock()
        self.assertIs(db_recovery.ensure_connection(conn, connect), conn)
        connect.assert_not_called()
        conn.close.assert_not_called()

    def test_disconnect_then_failed_reconnect_then_success(self):
        old, new = Mock(), Mock()
        old.ping.side_effect = RuntimeError('DPY-4011: closed')
        connect = Mock(side_effect=[RuntimeError('DPY-6005: cannot connect'), new])
        sleeps = Mock()
        self.assertIs(db_recovery.ensure_connection(old, connect, sleeps, Mock()), new)
        old.close.assert_called_once()
        self.assertEqual(connect.call_count, 2)
        self.assertEqual(sleeps.call_count, 2)
        self.assertGreaterEqual(sleeps.call_args_list[1].args[0], 10)
        new.ping.assert_called_once()

    def test_application_errors_are_not_retried(self):
        conn, connect = Mock(), Mock()
        conn.ping.side_effect = RuntimeError('ORA-00942: table missing')
        with self.assertRaises(RuntimeError):
            db_recovery.ensure_connection(conn, connect)
        connect.assert_not_called()

    def test_fresh_connection_after_ambiguous_claim(self):
        new = Mock()
        self.assertIs(db_recovery.ensure_connection(None, lambda: new), new)
        new.cursor.assert_not_called()  # recovery must never replay a claim/write


if __name__ == '__main__':
    unittest.main()
