"""
pytest configuration and fixtures for time_utils tests.
"""

from datetime import datetime, timedelta, timezone
from typing import Any

import pytest


@pytest.fixture
def utc_datetime() -> datetime:
    """Return a fixed UTC datetime for testing."""
    return datetime(2025, 1, 15, 12, 30, 45, 123456, tzinfo=timezone.utc)


@pytest.fixture
def naive_datetime() -> datetime:
    """Return a naive datetime (no timezone info) for testing."""
    return datetime(2025, 1, 15, 12, 30, 45, 123456)


@pytest.fixture
def local_datetime() -> datetime:
    """Return a datetime in local timezone for testing."""
    return datetime(2025, 1, 15, 12, 30, 45, 123456).astimezone()


@pytest.fixture
def non_utc_timezone() -> timezone:
    """Return a non-UTC timezone for testing."""
    return timezone(timedelta(hours=5, minutes=30))  # IST


@pytest.fixture
def datetime_with_custom_tz(non_utc_timezone: timezone) -> datetime:
    """Return a datetime with custom timezone for testing."""
    return datetime(2025, 1, 15, 12, 30, 45, 123456, tzinfo=non_utc_timezone)


@pytest.fixture
def mock_current_time(monkeypatch: Any) -> None:
    """Mock datetime.now() to return a fixed time."""
    fixed_time = datetime(2025, 1, 15, 12, 30, 45, 123456, tzinfo=timezone.utc)

    class MockDatetime(datetime):
        @classmethod
        def now(cls, tz: Any = None) -> datetime:
            if tz:
                return fixed_time.astimezone(tz)
            return fixed_time.replace(tzinfo=None)

    monkeypatch.setattr("time_utils.core.datetime", MockDatetime)
