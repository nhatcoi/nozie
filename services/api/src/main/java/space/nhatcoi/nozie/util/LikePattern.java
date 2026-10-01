package space.nhatcoi.nozie.util;

/** Builds LIKE patterns from user input with wildcards neutralised, always paired with {@link #ESCAPE}. */
public final class LikePattern {

    public static final char ESCAPE = '\\';

    private LikePattern() {
    }

    public static String contains(String input) {
        return "%" + escape(input) + "%";
    }

    public static String startsWith(String input) {
        return escape(input) + "%";
    }

    /** Pattern that matches everything, for optional-filter queries. */
    public static String any() {
        return "%";
    }

    private static String escape(String s) {
        return s.trim().toLowerCase().replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
