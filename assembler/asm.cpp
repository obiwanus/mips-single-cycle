#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <bitset>
#include <string>
#include <vector>

#define COUNT_OF(x) \
  ((sizeof(x) / sizeof(0 [x])) / ((size_t)(!(sizeof(x) % sizeof(0 [x])))))

static const int kMaxNameLen = 100;

struct String {
  char *text;
  int len;
};

enum Token_Type {
  Token__Unknown = 0,
  Token__Invalid,
  Token__Label,
  Token__Instruction,
  Token__Register,
  Token__Number,
  Token__Comma,
  Token__Identifier,
  Token__Newline,
  Token__OpenParen,
  Token__CloseParen,
};

// Must match above
const char *g_token_types[] = {
    "unknown", "invalid",    "label",   "instruction", "register",   "number",
    "comma",   "identifier", "newline", "openparen",   "closeparen",
};

enum Instruction_Type {
  I__unknown = 0,
  I__add,
  I__and,
  I__balrn,
  I__balrz,
  I__brn,
  I__brz,
  I__jalr,
  I__jr,
  I__nor,
  I__or,
  I__slt,
  I__sll,
  I__srl,
  I__sub,

  I__RFORMAT,

  I__addi,
  I__andi,
  I__balmn,
  I__balmz,
  I__beq,
  I__beqal,
  I__bmn,
  I__bmz,
  I__bne,
  I__bneal,
  I__jalm,
  I__jalpc,
  I__jm,
  I__jpc,
  I__lw,
  I__ori,
  I__sw,

  I__IFORMAT,

  I__baln,
  I__balz,
  I__bn,
  I__bz,
  I__jal,
  I__j,

  I__COUNT,
};

// Note: has to be in the same order as the enum above
static const char *g_mnemonics[] = {
    "unknown", "add",   "and",   "balrn", "balrz", "brn",   "brz", "jalr",
    "jr",      "nor",   "or",    "slt",   "sll",   "srl",   "sub", NULL,
    "addi",    "andi",  "balmn", "balmz", "beq",   "beqal", "bmn", "bmz",
    "bne",     "bneal", "jalm",  "jalpc", "jm",    "jpc",   "lw",  "ori",
    "sw",      NULL,    "baln",  "balz",  "bn",    "bz",    "jal", "j",
};

static const char *g_reg_names[] = {
    "zero", "at", "v0", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2",
    "t3",   "t4", "t5", "t6", "t7", "s0", "s1", "s2", "s3", "s4", "s5",
    "s6",   "s7", "t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
};

struct Symbol_Table_Entry {
  std::string str;
  bool resolved = false;
  int value = 0;
};

static std::vector<Symbol_Table_Entry> g_symbol_table;

struct Identifier {
  bool resolved_ = false;
  int index_ = -1;
  int instr_address_ = 0;  // memory address of the instruction it's used in

  Identifier() {}

  Identifier(int index, int instr_num) {
    index_ = index;
    instr_address_ = instr_num;  // note: word address, not byte address!
  }

  int as_offset() { return this->resolved_value(true); }

  int as_address() { return this->resolved_value(false); }

  int resolved_value(bool offset) {
    assert(index_ >= 0);
    Symbol_Table_Entry entry = g_symbol_table[index_];
    if (!entry.resolved) {
      printf("Unknown identifier %s\n", entry.str.c_str());
      exit(1);
    }
    if (offset) {
      // Calculate offset from the instruction using it to the label
      // note: branches use offsets from the next instruction (PC + 4)
      // to the target, hence + 1 below
      return entry.value - (instr_address_ + 1);
    }
    return entry.value;
  }
};

struct Instruction {
  Instruction_Type type;
  short rs;  // register numbers
  short rt;
  short rd;
  short shamt;         // shift amount
  int16_t imm16;       // immediate
  Identifier address;  // 16 bit offset or 26 bit address

  // Calculated fields
  short opcode;
  short func;

  bool is_R_type() { return type < I__RFORMAT; }
  bool is_I_type() { return I__RFORMAT < type && type < I__IFORMAT; }
  bool is_J_type() { return I__IFORMAT < type; }

  bool contains_offset() {
    return type == I__beq || type == I__beqal || type == I__bne ||
           type == I__bneal || type == I__jalpc || type == I__jpc;
  }

  void set_opcode_and_func() {
    // clang-format off
    switch (this->type) {
      case I__add: { opcode = 0; func = 0x20; break; }
      case I__and: { opcode = 0; func = 0x24; break; }
      case I__balrn: { opcode = 0; func = 23; break; }
      case I__balrz: { opcode = 0; func = 22; break; }
      case I__brn: { opcode = 0; func = 21; break; }
      case I__brz: { opcode = 0; func = 20; break; }
      case I__jalr: { opcode = 0; func = 9; break; }
      case I__jr: { opcode = 0; func = 8; break; }
      case I__nor: { opcode = 0; func = 0x27; break; }
      case I__or: { opcode = 0; func = 0x25; break; }
      case I__slt: { opcode = 0; func = 0x2a; break; }
      case I__sll: { opcode = 0; func = 0; break; }
      case I__srl: { opcode = 0; func = 0x2; break; }
      case I__sub: { opcode = 0; func = 0x22; break; }
      case I__addi: { opcode = 0x8; func = 0; break; }
      case I__andi: { opcode = 0xC; func = 0; break; }
      case I__balmn: { opcode = 23; func = 0; break; }
      case I__balmz: { opcode = 22; func = 0; break; }
      case I__beq: { opcode = 0x4; func = 0; break; }
      case I__beqal: { opcode = 44; func = 0; break; }
      case I__bmn: { opcode = 21; func = 0; break; }
      case I__bmz: { opcode = 20; func = 0; break; }
      case I__bne: { opcode = 0x5; func = 0; break; }
      case I__bneal: { opcode = 45; func = 0; break; }
      case I__jalm: { opcode = 19; func = 0; break; }
      case I__jalpc: { opcode = 31; func = 0; break; }
      case I__jm: { opcode = 18; func = 0; break; }
      case I__jpc: { opcode = 30; func = 0; break; }
      case I__lw: { opcode = 0x23; func = 0; break; }
      case I__ori: { opcode = 0xD; func = 0; break; }
      case I__sw: { opcode = 0x2B; func = 0; break; }
      case I__baln: { opcode = 27; func = 0; break; }
      case I__balz: { opcode = 26; func = 0; break; }
      case I__bn: { opcode = 25; func = 0; break; }
      case I__bz: { opcode = 24; func = 0; break; }
      case I__jal: { opcode = 0x3; func = 0; break; }
      case I__j: { opcode = 0x2; func = 0; break; }
      default: {
        printf("ERROR: Unknown instruction type: %d", (int)this->type);
        exit(1);
      }
    };
    // clang-format on
  }
};

struct Token {
  Token_Type type = Token__Unknown;
  int value = 0;
  int line_num;

  const char *repr() { return g_token_types[(int)type]; }
};

bool is_whitespace(char c) { return c == ' ' || c == '\t'; }

bool is_alpha(char c) {
  return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z');
}

bool is_token(char c) { return c == '\n' || c == ',' || c == '(' || c == ')'; }

bool is_num(char c) { return ('0' <= c && c <= '9'); }

Instruction_Type match_instruction(char *string) {
  if (strlen(string) > 5) return I__unknown;
  // Linear search, but it's OK
  for (size_t i = 1; i < COUNT_OF(g_mnemonics); ++i) {
    if (g_mnemonics[i] != NULL && strcmp(g_mnemonics[i], string) == 0) {
      return (Instruction_Type)i;
    }
  }
  return I__unknown;
}

int match_register(char *string) {
  for (size_t i = 0; i < COUNT_OF(g_reg_names); ++i) {
    if (strcmp(g_reg_names[i], string) == 0) {
      return i;
    }
  }
  return -1;
}

int match_identifier(std::string identifier) {
  int index = 0;
  for (auto &str : g_symbol_table) {
    if (str.str == identifier) {
      return index;
    }
    index++;
  }
  return -1;
}

int find_or_add_identifier(std::string identifier) {
  int num = match_identifier(identifier);
  Symbol_Table_Entry entry;
  entry.str = identifier;
  if (num == -1) {
    num = g_symbol_table.size();
    g_symbol_table.push_back(entry);
  }
  return num;
}

int parse_int(char *string) {
  long value = strtol(string, NULL, 0);
  if (value == 0 && strcmp(string, "0") != 0) {
    printf("Warning: parsing %s as 0\n", string);
  }
  return (int)value;
}

struct Tokenizer {
  int at_ = 0;
  int line_num_ = 1;
  int text_len_;
  char *text_ = NULL;
  std::vector<Token> tokens_;

  Tokenizer(String source) {
    text_ = source.text;
    text_len_ = source.len;
    tokens_.reserve(1000);
  }

  void process_source() {
    while (at_ < text_len_) {
      this->eat_whitespace_and_comments();
      Token token = this->read_token();
      if (token.type == Token__Unknown) {
        printf("Unknown token on line %d\n", line_num_);
        exit(1);
      }
      if (token.type == Token__Invalid) {
        printf("Invalid token on line %d\n", line_num_);
        exit(1);
      }
      tokens_.push_back(token);
    }
  }

  Token read_token() {
    Token token = {};
    token.type = Token__Unknown;
    token.line_num = line_num_;

    if (is_token(text_[at_])) {
      char c = text_[at_];
      if (c == '\n') {
        token.type = Token__Newline;
        line_num_++;
      } else if (c == ',') {
        token.type = Token__Comma;
      } else if (c == '(') {
        token.type = Token__OpenParen;
      } else if (c == ')') {
        token.type = Token__CloseParen;
      } else {
        printf("Token not listed here\n");
        exit(1);
      }
      at_++;
      return token;
    }

    // Read token into buffer
    int token_len = 0;
    char buffer[kMaxNameLen];
    while (!is_whitespace(text_[at_]) && !is_token(text_[at_])) {
      buffer[token_len++] = text_[at_++];
    }
    buffer[token_len] = '\0';
    if (token_len <= 0 || token_len >= kMaxNameLen) {
      token.type = Token__Invalid;
      return token;
    }

    // Recognize the token
    char first_char = buffer[0];
    if (is_alpha(first_char)) {
      char last_char = buffer[token_len - 1];
      if (last_char == ':') {
        token.type = Token__Label;
        buffer[token_len - 1] = '\0';  // delete the colon
        std::string label = buffer;
        token.value = find_or_add_identifier(label);
      } else {
        Instruction_Type instruction = match_instruction(buffer);
        if (instruction == I__unknown) {
          token.type = Token__Identifier;
          std::string identifier = buffer;
          token.value = find_or_add_identifier(identifier);
        } else {
          token.type = Token__Instruction;
          token.value = (int)instruction;
        }
      }
    } else if (first_char == '$') {
      token.type = Token__Register;
      int reg_number = match_register(buffer + 1);
      if (reg_number < 0) {
        token.type = Token__Unknown;
      }
      token.value = reg_number;
    } else if (is_num(first_char) || (first_char == '-' && is_num(buffer[1]))) {
      token.type = Token__Number;
      token.value = parse_int(buffer);
    }

    return token;
  }

  void eat_whitespace_and_comments() {
    bool in_comment = false;
    while (at_ < text_len_) {
      char c = text_[at_];
      if (is_whitespace(c) || (in_comment && c != '\n')) {
        at_++;
      } else if (c == '#') {
        at_++;
        in_comment = true;
      } else {
        break;
      }
    }
  }
};

struct CodeGenerator {
  size_t at_ = 0;
  bool nice_print_;
  std::vector<Instruction> instructions_;
  std::vector<Token> tokens_;

  CodeGenerator(std::vector<Token> tokens, bool nice_print) {
    instructions_.reserve(100);
    tokens_ = tokens;  // copy but it's ok
    nice_print_ = nice_print;
  }

  int encode_instruction(Instruction i, char *at) {
    const int kLen = 40;
    std::string SPACE = nice_print_ ? " " : "";
    std::string instruction;
    instruction.reserve(kLen);
    i.set_opcode_and_func();  // not nice I know

    instruction += std::bitset<6>(i.opcode).to_string() + SPACE;

    if (i.is_R_type()) {
      instruction += std::bitset<5>(i.rs).to_string() + SPACE +
                     std::bitset<5>(i.rt).to_string() + SPACE +
                     std::bitset<5>(i.rd).to_string() + SPACE +
                     std::bitset<5>(i.shamt).to_string() + SPACE +
                     std::bitset<6>(i.func).to_string();
    } else if (i.is_I_type()) {
      std::string immediate;
      if (i.contains_offset()) {
        immediate = std::bitset<16>(i.address.as_offset()).to_string();
      } else {
        immediate = std::bitset<16>(i.imm16).to_string();
      }
      instruction += std::bitset<5>(i.rs).to_string() + SPACE +
                     std::bitset<5>(i.rt).to_string() + SPACE + immediate;
    } else if (i.is_J_type()) {
      instruction += std::bitset<26>(i.address.as_address()).to_string();
    } else {
      assert(!"Invalid code path");
    }

    if (SPACE == "") {
      // output in bytes (little endian)
      sprintf(at, "%s\n%s\n%s\n%s\n", instruction.substr(24, 8).c_str(),
              instruction.substr(16, 8).c_str(),
              instruction.substr(8, 8).c_str(),
              instruction.substr(0, 8).c_str());
    } else {
      sprintf(at, "%s\n", instruction.c_str());  // in words
    }

    return strlen(at);
  }

  String generate() {
    this->read_instructions();  // transform tokens into instructions

    // Allocate memory for result
    String result = {};
    result.len = (32 + 10) * instructions_.size();
    result.text = (char *)malloc(result.len * sizeof(char));

    char *at = result.text;
    for (auto instruction : instructions_) {
      int chars_written = this->encode_instruction(instruction, at);
      at += chars_written;
    }

    return result;
  }

  void advance_token() { at_++; }
  Token get_token() { return tokens_[at_]; }
  Token get_token_and_advance() { return tokens_[at_++]; }
  bool tokens_left() { return at_ < tokens_.size(); }

  void check_label() {
    this->eat_newlines();
    Token token = this->get_token();
    if (token.type == Token__Label) {
      // Register label
      Symbol_Table_Entry &entry = g_symbol_table[token.value];
      if (entry.resolved) {
        printf("Redefinition of label '%s' on line %d", entry.str.c_str(),
               token.line_num);
        exit(1);
      }
      entry.value = instructions_.size();  // = instruction word address!
                                           // (i.e. proper byte address / 4)
      entry.resolved = true;

      this->advance_token();
    }
    this->eat_newlines();
  }

  void eat_newlines() {
    Token token = this->get_token();
    while (token.type == Token__Newline) {
      this->advance_token();
      token = this->get_token();
    }
  }

  Instruction read_instruction() {
    Instruction i = {};
    i.type = this->expect_instruction();

    switch (i.type) {
      // ===== R-format

      case I__add:
      case I__and:
      case I__nor:
      case I__or:
      case I__slt:
      case I__sub: {
        // rd, rs, rt
        i.rd = this->expect_register();
        this->expect_comma();
        i.rs = this->expect_register();
        this->expect_comma();
        i.rt = this->expect_register();
      } break;

      case I__balrn:
      case I__balrz:
      case I__jalr: {
        // rs, rd
        i.rs = this->expect_register();
        this->expect_comma();
        i.rd = this->expect_register();
      } break;

      case I__brn:
      case I__brz:
      case I__jr: {
        // rs
        i.rs = this->expect_register();
      } break;

      case I__sll:
      case I__srl: {
        // rd, rt, shamt
        i.rd = this->expect_register();
        this->expect_comma();
        i.rt = this->expect_register();
        this->expect_comma();
        i.shamt = this->expect_number();
      } break;

      // ===== I-format

      case I__addi:
      case I__andi:
      case I__ori: {
        // rt, rs, imm
        i.rt = this->expect_register();
        this->expect_comma();
        i.rs = this->expect_register();
        this->expect_comma();
        i.imm16 = this->expect_immediate();
      } break;

      case I__balmn:
      case I__balmz:
      case I__jalm:
      case I__lw:
      case I__sw: {
        // rt, imm(rs)
        i.rt = this->expect_register();
        this->expect_comma();
        i.imm16 = this->expect_immediate();
        this->expect_open_paren();
        i.rs = this->expect_register();
        this->expect_close_paren();
      } break;

      case I__beq:
      case I__beqal:
      case I__bne:
      case I__bneal: {
        // rs, rt, offset
        i.rs = this->expect_register();
        this->expect_comma();
        i.rt = this->expect_register();
        this->expect_comma();
        i.address = this->expect_identifier();
      } break;

      case I__bmn:
      case I__bmz:
      case I__jm: {
        // imm(rs)
        i.imm16 = this->expect_immediate();
        this->expect_open_paren();
        i.rs = this->expect_register();
        this->expect_close_paren();
      } break;

      case I__jalpc: {
        // rt, offset
        i.rt = this->expect_register();
        this->expect_comma();
        i.address = this->expect_identifier();
      } break;

      case I__jpc: {
        // offset
        i.address = this->expect_identifier();
      } break;

      // ===== J-format

      case I__baln:
      case I__balz:
      case I__bn:
      case I__bz:
      case I__jal:
      case I__j: {
        // target26
        i.address = this->expect_identifier();
      } break;

      default: { printf("Unknown instruction (code %d)", (int)i.type); } break;
    }

    if (this->tokens_left()) {
      this->expect_newline();  // every instruction should be on new line
    }

    return i;
  }

  short expect_register() {
    Token token = this->expect_token(Token__Register);
    return (short)token.value;
  }

  short expect_number() {
    Token token = this->expect_token(Token__Number);
    return (short)token.value;
  }

  int16_t expect_immediate() { return (int16_t) this->expect_number(); }

  Identifier expect_identifier() {
    Token token = this->expect_token(Token__Identifier);
    return Identifier(token.value, instructions_.size());
  }

  Instruction_Type expect_instruction() {
    Token token = this->expect_token(Token__Instruction);
    return (Instruction_Type)token.value;
  }

  Token expect_token(Token_Type type) {
    Token token = this->get_token_and_advance();
    if (token.type != type) {
      const char *expected = g_token_types[(int)type];
      printf("Syntax error on line %d: Expected %s, got %s\n", token.line_num,
             expected, token.repr());
      exit(1);
    }
    return token;
  }

  void expect_newline() { this->expect_token(Token__Newline); }
  void expect_comma() { this->expect_token(Token__Comma); }
  void expect_open_paren() { this->expect_token(Token__OpenParen); }
  void expect_close_paren() { this->expect_token(Token__CloseParen); }

  void read_instructions() {
    while (this->tokens_left()) {
      this->check_label();
      if (!this->tokens_left()) break;
      Instruction instruction = this->read_instruction();
      instructions_.push_back(instruction);
    }
  }
};

String read_file_into_string(const char *filename) {
  String result = {};
  FILE *file = fopen(filename, "r");
  if (file == NULL) {
    result.text = NULL;
    result.len = -1;
    return result;
  }
  int size = 0;
  fseek(file, 0, SEEK_END);
  size = ftell(file);
  fseek(file, 0, SEEK_SET);

  result.text = (char *)malloc(size * sizeof(char));
  fread(result.text, size, sizeof(char), file);
  result.len = size;

  return result;
}

int main(int argc, const char *argv[]) {
  char *filename =
      (char *)"../processor/programs/1_fefe.mips";
  bool nice_print = false;
  if (argc > 1) {
    // printf("format: asm <file>\n");
    // return 0;
    filename = (char *)argv[1];
    if (argc > 2) {
      nice_print = true;
    }
  }
  String source = read_file_into_string(filename);
  if (source.len <= 0) {
    printf("Can't open file '%s'\n", filename);
    return 1;
  }
  Tokenizer tokenizer = Tokenizer(source);
  tokenizer.process_source();

  CodeGenerator code = CodeGenerator(tokenizer.tokens_, nice_print);
  String generated_code = code.generate();
  printf("%s", generated_code.text);

  return 0;
}
