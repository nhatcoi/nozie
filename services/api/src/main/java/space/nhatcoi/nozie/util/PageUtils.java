package space.nhatcoi.nozie.util;

import java.util.Set;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import space.nhatcoi.nozie.constant.PaginationConstants;
import space.nhatcoi.nozie.exception.ApiException;
import space.nhatcoi.nozie.exception.ErrorCode;

public final class PageUtils {

    private PageUtils() {
    }

    /** Clamps page/size to safe bounds; the caller supplies an already-trusted sort. */
    public static Pageable of(int page, int size, Sort sort) {
        return PageRequest.of(Math.max(page, 0),
                Math.min(Math.max(size, 1), PaginationConstants.MAX_PAGE_SIZE), sort);
    }

    public static Pageable of(int page, int size) {
        return of(page, size, Sort.unsorted());
    }

    /** Builds a sort only from a whitelist so clients can never sort by arbitrary columns. */
    public static Sort whitelistedSort(Set<String> allowed, String field, String direction) {
        if (!allowed.contains(field)) {
            throw new ApiException(ErrorCode.INVALID_SORT);
        }
        return Sort.by("asc".equalsIgnoreCase(direction) ? Sort.Direction.ASC : Sort.Direction.DESC, field);
    }
}
