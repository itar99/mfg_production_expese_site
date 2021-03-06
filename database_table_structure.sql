-- phpMyAdmin SQL Dump
-- version 3.5.8.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 20, 2015 at 07:39 PM
-- Server version: 5.5.42-37.1-log
-- PHP Version: 5.4.23

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `itarswor_joom`
--
CREATE DATABASE `itarswor_joom` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `itarswor_joom`;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `uid` varchar(50) DEFAULT NULL,
  `password` varbinary(200) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `name`, `uid`, `password`, `last_login`) VALUES


-- --------------------------------------------------------

--
-- Table structure for table `expense_category`
--

DROP TABLE IF EXISTS `expense_category`;
CREATE TABLE IF NOT EXISTS `expense_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `expense_category`
--

INSERT INTO `expense_category` (`id`, `name`, `description`) VALUES
(1, 'testing', 'a test category'),
(2, 'production supplies', 'supplies for production like resin, filler, etc');

-- --------------------------------------------------------

--
-- Table structure for table `expense_tax_category`
--

DROP TABLE IF EXISTS `expense_tax_category`;
CREATE TABLE IF NOT EXISTS `expense_tax_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
CREATE TABLE IF NOT EXISTS `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `expense_dt` date DEFAULT NULL,
  `company` varchar(200) DEFAULT NULL,
  `tax_category` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `project` int(11) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `name`, `description`, `expense_dt`, `company`, `tax_category`, `category`, `amount`, `project`, `entered_dt`, `entered_uid`, `updated_dt`, `updated_uid`) VALUES
(1, 'test', NULL, '0000-00-00', 'somecompany', NULL, NULL, '10.00', NULL, '0000-00-00 00:00:00', NULL, NULL, NULL),
(2, 'test', NULL, '0000-00-00', 'somecompany', NULL, 2, '10.00', 1, '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00', NULL),
(3, 'test', NULL, '0000-00-00', 'somecompany', NULL, NULL, '10.00', NULL, '0000-00-00 00:00:00', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gd_category`
--

DROP TABLE IF EXISTS `gd_category`;
CREATE TABLE IF NOT EXISTS `gd_category` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `description` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `sort` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gd_customers`
--

DROP TABLE IF EXISTS `gd_customers`;
CREATE TABLE IF NOT EXISTS `gd_customers` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(200) CHARACTER SET latin1 NOT NULL,
  `country` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `postal_code` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `address1` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `address2` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `email` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `city` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `state` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `password` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `activate_code` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `admin` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gd_orders`
--

DROP TABLE IF EXISTS `gd_orders`;
CREATE TABLE IF NOT EXISTS `gd_orders` (
  `id` int(11) NOT NULL DEFAULT '0',
  `customer_id` int(11) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `notes` text CHARACTER SET latin1
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gd_pieces`
--

DROP TABLE IF EXISTS `gd_pieces`;
CREATE TABLE IF NOT EXISTS `gd_pieces` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(200) CHARACTER SET latin1 DEFAULT NULL,
  `description` text CHARACTER SET latin1
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gd_products`
--

DROP TABLE IF EXISTS `gd_products`;
CREATE TABLE IF NOT EXISTS `gd_products` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(100) CHARACTER SET latin1 NOT NULL,
  `description` text CHARACTER SET latin1,
  `price` decimal(5,2) DEFAULT NULL,
  `images` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `ha` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gd_products`
--

-- --------------------------------------------------------

--
-- Table structure for table `gd_status`
--

DROP TABLE IF EXISTS `gd_status`;
CREATE TABLE IF NOT EXISTS `gd_status` (
  `id` int(11) NOT NULL DEFAULT '0',
  `status` varchar(40) CHARACTER SET latin1 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(100) NOT NULL,
  `text` varchar(100) NOT NULL,
  `url` varchar(2048) DEFAULT NULL,
  `master_id` int(11) DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `menu_name`, `text`, `url`, `master_id`, `image`) VALUES
(1, 'ks', 'home', '', 0, NULL),
(2, 'ks', 'orders', '/ks/orders.cgi', 0, NULL),
(3, 'ks', 'product report', '/ks/product_report.cgi', 0, NULL),
(4, 'ks', 'orders ready', '/ks/order_list.cgi', 2, NULL),
(5, 'ks', 'orders 2', '/ks/orders.cgi', 4, NULL),
(6, 'pledge_mgr', 'Customer List', 'customers.cgi', 0, ''),
(7, 'pledge_mgr', 'Product Report', 'product_report.cgi', 0, ''),
(8, 'pledge_mgr', 'Orders', 'orders.cgi', 0, ''),
(9, 'pledge_mgr', 'Order List', 'order_list.cgi', 0, ''),
(10, 'pledge_mgr', 'Logout', 'login.cgi?a=logout', 0, ''),
(11, 'admin', 'Home', 'home.cgi', 0, NULL),
(12, 'admin', 'Expenses', 'expenses.cgi', 0, NULL),
(13, 'admin', 'Expense Category', 'table_edit.cgi?tid=5', 12, NULL),
(14, 'admin', 'Expense Tax Category', 'table_edit.cgi?tid=6', 12, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `goal` varchar(500) DEFAULT NULL,
  `start_dt` date DEFAULT NULL,
  `end_dt` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `name`, `description`, `goal`, `start_dt`, `end_dt`) VALUES
(1, 'test', 'a test project', 'test the system', '0000-00-00', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `table_edit`
--

DROP TABLE IF EXISTS `table_edit`;
CREATE TABLE IF NOT EXISTS `table_edit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `columns` varchar(250) DEFAULT NULL,
  `edit` bit(1) DEFAULT b'1',
  `del` bit(1) DEFAULT b'0',
  `insert` bit(1) DEFAULT b'1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `table_edit`
--

INSERT INTO `table_edit` (`id`, `name`, `columns`, `edit`, `del`, `insert`) VALUES
(1, 'test_edit', '*', b'1', b'0', b'1'),
(2, 'menus', '*', b'1', b'1', b'1'),
(3, 'expenses', '*', b'1', b'1', b'1'),
(4, 'projects', '*', b'1', b'1', b'1'),
(5, 'expense_category', '*', b'1', b'1', b'1'),
(6, 'expense_tax_category', '*', b'1', b'1', b'1');

-- --------------------------------------------------------

--
-- Table structure for table `test_edit`
--

DROP TABLE IF EXISTS `test_edit`;
CREATE TABLE IF NOT EXISTS `test_edit` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(100) CHARACTER SET latin1 NOT NULL,
  `description` text CHARACTER SET latin1,
  `price` decimal(5,2) DEFAULT NULL,
  `images` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `ha` int(11) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `model` varchar(20) CHARACTER SET latin1 DEFAULT NULL,
  `selected` bit(1) DEFAULT NULL,
  `added_dt` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `test_edit`
--

INSERT INTO `test_edit` (`id`, `name`, `description`, `price`, `images`, `sort`, `category`, `ha`, `stock`, `model`, `selected`, `added_dt`) VALUES
(1, 'Basic Dungeon Set Unpainted BROWN', 'This is your basic dungeon set. The set comes unpainted and cast in brown resin. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '100.00', 'basic_dungeon_set.JPG', 10, 3, 1, 0, 'ABC-123', b'1', '0000-00-00'),
(2, 'Basic Dungeon Set Painted BROWN', 'This is your basic dungeon set. The set comes Painted in a grey color scheme. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '90.00', 'basic_dungeon_set.JPG', 20, 3, 1, 1, NULL, NULL, NULL),
(3, 'Deluxe Dungeon Set Unpainted BROWN', 'This set is twice the size of the basic set and comes unpainted and cast in brown resin. Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '90.00', 'deluxe_dungeon_set.jpg', 30, 3, 1, 1, NULL, NULL, NULL),
(4, 'Deluxe Dungeon Set Painted BROWN', 'This set is twice the size of the basic set and comes painted in a brown color scheme. Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '175.00', 'deluxe_dungeon_set.jpg', 40, 3, NULL, 0, NULL, NULL, NULL),
(5, 'Intermediate Dungeon Set Unpainted BROWN', 'This set is three of our basic sets and comes cast in brown resin. Set Contains: 12 straight 3x2 hallway sections 6 straight 3x3 hallway sections 6 straight 3x1 hallway sections 6 L hallway sections 6 T hallway sections 3 four way hallway intersection 12 room walls 12 room corners 6 3x3 floor 6 3x2 floors 6 3x1 floors 6 2x2 floors 6 doorways 12 doors A total of 111 pieces', '135.00', NULL, 50, 3, 1, 0, NULL, NULL, NULL),
(6, 'Ultimate Dungeon Set Unpainted BROWN', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes unpainted and cast in brown resin  Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '180.00', 'ultimate_dungeon_set.jpg', 60, 3, 1, 4, NULL, NULL, NULL),
(7, 'Ultimate Dungeon Set Painted BROWN', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes painted in a brown color scheme  Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '340.00', 'ultimate_dungeon_set.jpg', 70, 3, 1, 0, NULL, NULL, NULL),
(8, 'Basic Accessory Set', 'The Basic Accessory set includes: Barrels and Crates, Wooden Chests, Grain Sacks, Urns, Fire Sources, Crystals, Open Coffins, Tombstones, and Sarcofagus sets.', '25.00', NULL, 80, 3, 1, 10, NULL, NULL, NULL),
(9, 'Door set', 'A set of 4 doors.  One of each type.  Add extra doors to your set.', '3.00', 'doors.JPG', 90, 3, 1, 10, NULL, NULL, NULL),
(10, 'Room Set', 'A set of extra walls and corners to make rooms.  4 walls and 4 corners.', '10.00', 'room_set.jpg', 100, 3, 1, 10, NULL, NULL, NULL),
(11, 'Floor Set', 'A set of extra floors to make that one really large room.', '5.00', 'floor_set.jpg', 110, 3, 1, 10, NULL, NULL, NULL),
(12, 'Hallway Set', 'A set of 9 hallway pieces.  Create some extra hallways for your dungeon.', '15.00', 'hallway_set.jpg', 120, 3, 1, 10, NULL, NULL, NULL),
(13, 'Barrels and Crates', '3 long crates, 3 square crates, 3 open crates with lid, 3 closed barrels, 3 open barrels, 3 small barrels.  A total of 18 pieces.', '7.00', 'barrels_crates.jpg', 130, 2, 1, 215, 'IWS-ACC-005', NULL, NULL),
(14, 'Wooden Chests', 'A set of 6 wooden chests.', '2.00', 'wooden_chests.jpg', 140, 2, 1, 203, NULL, NULL, NULL),
(15, 'Grain Sacks', 'A set of 4 grain sacks, 2 open grain sacks, and a pile of grain sacks.  A total of 7 pieces.', '2.00', 'grain_sacks.jpg', 150, 2, 1, 227, NULL, NULL, NULL),
(16, 'Urns', 'A set of 6 urns', '3.00', 'urns.jpg', 160, 2, 1, 50, NULL, NULL, NULL),
(17, 'Fire Sources', 'A set of 2 firestands, a brazier, a campfire and a burned out campfire.', '3.00', 'fire_sources.jpg', 170, 2, 1, 6, NULL, NULL, NULL),
(18, 'Bookcase with Books', 'A bookcase with 10 books and 2 scrolls', '2.00', 'bookcase_books.jpg', 180, 2, NULL, 10, NULL, NULL, NULL),
(19, 'Bookcase with Bottles', 'A bookcase with 20 bottles', '2.00', 'bookcase_bottles.jpg', 190, 2, NULL, 10, NULL, NULL, NULL),
(20, 'Throne', 'A throne', '5.00', 'throne.jpg', 200, 2, NULL, 15, NULL, NULL, NULL),
(21, 'Lanterns', 'A set of 12 lamps and lanterns.  Each set contains 4 of each unique light source.', '2.00', 'lanterns.jpg', 210, 2, NULL, 5, NULL, NULL, NULL),
(22, 'Table and Chairs', 'A set of two tables and 8 chairs.', '5.00', 'table_chairs.jpg', 220, 2, NULL, 4, NULL, NULL, NULL),
(23, 'Crystal Formations', '4 Crystal formations', '3.00', 'crystals.JPG', 230, 2, 1, 42, NULL, NULL, NULL),
(24, 'Human Skulls', 'A set of 10 Human Skulls.  This item comes unpainted.', '3.00', NULL, 240, 2, NULL, 10, NULL, NULL, NULL),
(25, 'Orc Skulls', 'A set of 10 Orc Skulls.  This item comes unpainted.', '3.00', NULL, 250, 2, NULL, 10, NULL, NULL, NULL),
(26, 'Cyclops Skulls', 'A set of 10 Cyclops Skulls. This item comes unpainted.', '3.00', NULL, 260, 2, NULL, 10, NULL, NULL, NULL),
(27, 'Cow Skulls', 'A set of 10 Cow Skulls.  This item comes unpainted.', '3.00', NULL, 270, 2, NULL, 10, NULL, NULL, NULL),
(28, 'Round Shields', 'A set of 12 shields (3 of each)', '5.00', 'shields.jpg', 280, 2, NULL, 36, NULL, NULL, NULL),
(29, 'Open Coffins', 'A set of two open coffins with lids.', '2.00', 'coffins.JPG', 290, 2, 1, 25, NULL, NULL, NULL),
(30, 'Tombstones', 'A set of 15 tombstones.', '2.00', 'tombstones.jpg', 300, 2, 1, 36, NULL, NULL, NULL),
(31, 'Egyptian Sarcophagus Set', 'An Egyptian Sarcophagus Set containing sarcophagus, lid, and mummy.', '2.00', 'sarcophagus.jpg', 310, 2, 1, 286, NULL, NULL, NULL),
(32, 'Sphinx with base', 'A sphinx statue with base.', '3.00', 'sphinx.jpg', 320, 2, 1, 79, NULL, NULL, NULL),
(33, 'International Shipping', NULL, '20.00', NULL, 1000, 3, NULL, 72, NULL, NULL, NULL),
(35, 'Doorway tile and doors', 'A doorway tile with one of each of unique doors (5 pieces total).', '6.00', NULL, 85, 1, 1, 10, NULL, NULL, NULL),
(36, 'Stair Set', 'A set of 2 straight stairs.  These stairs will fit inside the standard 2" hallway or work great in a room.', '4.00', NULL, 93, 1, 1, 49, NULL, NULL, NULL),
(37, 'Curved Stairs', 'A set of 2 circular stairway pieces.  Great for adding that circular staircase.', '4.00', NULL, 97, 1, 1, 35, NULL, NULL, NULL),
(38, 'Treasure Sacks', 'A set of 8 sacks.', '2.00', NULL, 330, 2, 0, 30, NULL, NULL, NULL),
(39, 'War Chests', 'A set of 2 locked treasure chests.  These treasure sacks are 1.25" wide by  0.6" deep by 0.7" tall.', '3.00', NULL, 340, 2, NULL, 179, NULL, NULL, NULL),
(40, 'Collapsed tunnel section', 'A cavein piece that fits perfectly inside the standard 2" hallway piece.', '4.00', NULL, 87, 1, 1, 4, NULL, NULL, NULL),
(41, 'Mixed Skull Set', 'A mixed set of skulls.  Each set contains 3 of each skull for a total of 12 skulls.', '4.00', NULL, 275, 2, NULL, 20, NULL, NULL, NULL),
(42, 'Torture Equipment', 'A set of 4 pieces fit for any torture chamber.  A spikey chair, a pillory, manacles on a pole, and an iron maiden.', '7.00', NULL, 350, 2, NULL, 29, NULL, NULL, NULL),
(43, 'Altar, basin and benches', 'Set contains: An altar, a stone basin, 6 gothic benches, 2 low gothic walls.', '10.00', NULL, 360, 2, NULL, 5, NULL, NULL, NULL),
(44, 'Altar and basin', 'ust the Altar and Basin.  This item comes unpainted.', '5.00', NULL, 370, 2, NULL, 35, NULL, NULL, NULL),
(45, 'Mixed Statue Set', 'A set of three statues.  One each of woman, totem, and cherub on a plineth.  This item coms unpainted.', '7.00', NULL, 380, 2, NULL, 48, NULL, NULL, NULL),
(46, 'Woman Statues', 'A set of three statues of a woman.  This item comes unpainted.', '7.00', NULL, 390, 2, NULL, 2, NULL, NULL, NULL),
(47, 'Totem Statues', 'A set of three statues of a totem.  This item comes unpainted.', '7.00', NULL, 400, 2, NULL, 5, NULL, NULL, NULL),
(48, 'Cherub Statues', 'A set of three statues of a cherub on a plineth.  This item comes unpainted.', '7.00', NULL, 410, 2, NULL, 5, NULL, NULL, NULL),
(49, 'Gargoyle', 'A set of six gargoyles.  This item comes unpainted.', '3.00', NULL, 420, 2, NULL, 15, NULL, NULL, NULL),
(50, 'Well', 'A single well that is 1.5" in diameter.  The campfire from the fire sources add on fits inside the well perfectly so combine this with the fire sources accessory (sold separately) and use it as a fire pit.  This item comes unpainted.', '2.00', NULL, 430, 2, NULL, 100, NULL, NULL, NULL),
(51, '45 degree wall', 'two 45 degree walls will be added to basic set (4 added to deluxe, 8 added to ultimate).', '4.00', NULL, 89, 1, 1, 8, NULL, NULL, NULL),
(52, '45 degree hallway', 'A set of two 45 degree hallway corners will be added to the basic dungeon set.  Deluxe sets get 4 sets and the Ultimate set gets 8.', '6.00', NULL, 88, 1, 1, 15, NULL, NULL, NULL),
(53, 'Accessory Set #2', 'contains: bookcase with books bookcase with bottles Throne lanterns Mixed skull set Round Shields Treasure Sacks war chests', '25.00', NULL, 81, 3, NULL, 3, NULL, NULL, NULL),
(54, 'Two Wheel Cart', 'A two wheel cart.  The wheels are cast separately.', '3.00', NULL, 440, 2, NULL, 52, NULL, NULL, NULL),
(55, 'Wall with barred drain', 'two walls with barred drains will be added to the basic set (4 for deluxe, and 8 for the ultimate sets).', '4.00', NULL, 89, 1, NULL, 20, NULL, NULL, NULL),
(56, 'Bar set', 'A set of modular bar pieces.  The bar pieces are 3/4" tall and 3/4" wide.  Set Contains: 4 two inch long bar sections 2 one inch long short bar sections 2 corner pieces (1" square) A total of 12" of bar for your adventurers drinking pleasure.', '10.00', NULL, 450, 2, NULL, 25, NULL, NULL, NULL),
(57, 'Bedroom set', 'A Bed, Armoire, 2 drawer dresser, 1 drawer dresser, and side table.  This item comes unpainted.', '6.00', NULL, 460, 2, NULL, 195, NULL, NULL, NULL),
(58, 'Tall Stairway Left', 'A 2" tall stairway piece', '2.00', NULL, 470, 1, NULL, 32, NULL, NULL, NULL),
(60, 'Archway', 'An archway piece that is perfect for making a bridge, or a balcony in a room.  The piece is 2" wide x 1" deep x 2" tall.', '2.00', NULL, 480, 1, 1, 22, NULL, NULL, NULL),
(61, 'Miniature Stair Adapter', 'An adapter to make it easy to use miniatures on stairs.  This piece is 1" square x 3/4" thick.  It works on any of our stairway pieces. (2 pieces)', '2.00', NULL, 490, 1, 1, 92, NULL, NULL, NULL),
(62, 'Tavern Accessories', 'A set of tableware suitable for serving adventurers in a tavern.<br>Set Contains:<br>3 pitchers<br>3 tankards<br>3 Goblets<br>3 empty plates<br>3 plates with a roast chicken<br>Total of 15 pieces.<br>', '3.00', NULL, 500, 2, NULL, 2, NULL, NULL, NULL),
(63, 'Fieldstone Columns', 'A set of two fieldstone columns.  Each column is 0.85" across at the base and 0.6" across at the top and is 2.5" tall.', '3.00', NULL, 510, 1, 1, 44, NULL, NULL, NULL),
(64, 'Flutted Columns', 'A set of two fluted columns.  Each column is 0.9" square at the base, 0.6" diameter at the top and 3" tall.', '3.00', NULL, 520, 1, 1, 41, NULL, NULL, NULL),
(65, 'Smooth Columns', 'A set of four smooth columns.  Each column is 0.7" square at the base, 0.45" diameter at the top and 2.5" tall. ', '3.00', NULL, 530, 1, 1, 30, NULL, NULL, NULL),
(66, 'Egyptian Hieroglyphic Columns', 'A set of two hieroglyphic columns.  Each column is 0.7" in diameter and 3.8" tall.', '3.00', NULL, 540, 1, 1, 14, NULL, NULL, NULL),
(67, 'Egyptian Columns', 'A set of two Egyptian Columns.  Each column is 1" in diameter and 4" tall.', '3.00', NULL, 550, 1, 1, 47, NULL, NULL, NULL),
(68, 'Round table and stools', 'A set of two round tables and eight stools.<br>This item comes unpainted.', '5.00', NULL, 560, 2, NULL, 10, NULL, NULL, NULL),
(69, 'Tavern Set', 'Set Contains:<br>Bar Set<br>2x Tavern Accessories<br>table and chairs (2 tables, 8 chairs)<br>Round Table and stools (2 tables, 8 stools)<br>8 stools<br>Total of 64 pieces<br>This item comes unpainted.', '28.00', NULL, 570, 2, NULL, 5, NULL, NULL, NULL),
(70, 'Halberd and weapon rack', 'This set contains 4 halberds and a weapons rack.  The halberds are separate from the rack and can either be glued in place or used elsewhere in your dungeon.  Total of 5 pieces.  This item comes unpainted.', '5.00', NULL, 580, 2, NULL, 25, NULL, NULL, NULL),
(71, 'Shield set #2', 'A set of 12 shields (3 of each design). This item comes unpainted', '5.00', NULL, 590, 2, NULL, 20, NULL, NULL, NULL),
(72, 'Secret Doors', 'A set of two secret doors', '2.00', NULL, 491, 1, 1, 14, NULL, NULL, NULL),
(73, 'Secret Passage wall', 'A set of two secret passage wall pieces.', '4.00', NULL, 492, 1, 1, 12, NULL, NULL, NULL),
(74, 'Egyptian Firestands', 'A set of 2 firestands with a sandblasted texture. Dimensions: 5/8" x 5/8" x 2" tall. This piece comes unpainted.', '3.00', NULL, 600, 2, 1, 59, NULL, NULL, NULL),
(75, 'Egyptian small obelisk ', 'A set of 2 small Egyptian Obelisks.  Dimensions: 1/2" square base x 1 1/2" tall.  This piece comes unpainted', '2.00', NULL, 610, 2, 1, 114, NULL, NULL, NULL),
(76, 'Standing Stones', 'A set of 6 ceremonial standing stones.  This piece comes unpainted.', '4.00', NULL, 620, 2, NULL, 15, NULL, NULL, NULL),
(77, 'Armor Stand', 'A stand of armor.  Great for any dungeon armory.  This item comes unpainted.', '2.00', NULL, 630, 2, NULL, 15, NULL, NULL, NULL),
(78, 'Egyptian Ram Sphinx', 'An Egyptian Sphinx with a ram''s head.  This item comes unpainted.', '3.00', NULL, 640, 2, NULL, 55, NULL, NULL, NULL),
(79, 'Dragon Statues', 'A set of two dragon statues.  This item comes unpainted.', '7.00', NULL, 650, 2, NULL, 35, NULL, NULL, NULL),
(80, 'Oriental Lion Statue', 'An oriental lion statue.  Dimensions: 1" x 0.6" wide x 1" tall.  This item comes unpainted.', '3.00', NULL, 660, 2, NULL, 5, NULL, NULL, NULL),
(81, 'Egyptian Pharaoh Seated', 'A seated pharaoh statue.  Dimensions: 0.75" wide x 1.1" x 2" tall.  This item comes unpainted.', '4.00', NULL, 670, 2, NULL, 10, NULL, NULL, NULL),
(82, 'Egyptian Bird Statues', 'A set of two Egyptian Bird Statues representing Horus.  Dimensions: 0.5" wide x 1" deep x 1.6" tall. This item is unpainted.', '4.00', NULL, 680, 2, NULL, 40, NULL, NULL, NULL),
(83, 'Tall Stairway Right', 'Just like the other tall stairway but a mirror image so it can go on the right side of the arch.', '2.00', NULL, 475, 1, 1, 35, NULL, NULL, NULL),
(84, 'Totem 1', 'An aztec totem statue.  Dimensions: 1" wide x 0.6" deep x 1.6" tall. This item comes unpainted.', '4.00', NULL, 690, 2, NULL, 35, NULL, NULL, NULL),
(85, 'Totem 2', 'An Aztec totem statue.  Dimensions: 1" wide x 0.6" deep x 2" tall.  This item comes unpainted.', '4.00', NULL, 700, 2, NULL, 7, NULL, NULL, NULL),
(86, 'Aztec Statue', 'An Aztec statue.  Dimensions: 1" wide x 0.6" deep x 1.6" tall. This item comes unpainted.', '4.00', NULL, 710, 2, NULL, 30, NULL, NULL, NULL),
(87, 'Aztec Statue 2', 'An Aztec Statue: An Aztec statue.  Dimensions: 1" wide x 0.5" deep x 2.9" tall. This item comes unpainted.', '4.00', NULL, 720, 2, NULL, 32, NULL, NULL, NULL),
(94, 'Ultimate Dungeon Set Painted GREY', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes painted in a grey color scheme (your choice) Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '340.00', 'ultimate_dungeon_set.jpg', 71, 3, 1, 0, NULL, NULL, NULL),
(93, 'Ultimate Dungeon Set Unpainted GREY', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes unpainted and cast in grey resin (your choice) Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '180.00', 'ultimate_dungeon_set.jpg', 61, 3, 1, 2, NULL, NULL, NULL),
(91, 'Deluxe Dungeon Set Painted GREY', 'This set is twice the size of the basic set and comes painted in a grey color scheme (your choice). Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '175.00', 'deluxe_dungeon_set.jpg', 41, 3, 1, 0, NULL, NULL, NULL),
(90, 'Deluxe Dungeon Set Unpainted GREY', 'This set is twice the size of the basic set and comes unpainted and cast in grey resin (your choice). Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '90.00', 'deluxe_dungeon_set.jpg', 31, 3, 1, 1, NULL, NULL, NULL),
(89, 'Basic Dungeon Set Painted GREY', 'This is your basic dungeon set. The set comes Painted in a grey color scheme (your choice). Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '90.00', 'basic_dungeon_set.JPG', 21, 3, 1, 0, NULL, NULL, NULL),
(88, 'Basic Dungeon Set Unpainted GREY', 'This is your basic dungeon set. The set comes unpainted and cast in grey resin. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '45.00', 'basic_dungeon_set.JPG', 11, 3, 1, 2, NULL, NULL, NULL),
(92, 'Intermediate Dungeon Set Unpainted GREY', 'This set is three of our basic sets and comes cast in grey resin (your choice). Set Contains: 12 straight 3x2 hallway sections 6 straight 3x3 hallway sections 6 straight 3x1 hallway sections 6 L hallway sections 6 T hallway sections 3 four way hallway intersection 12 room walls 12 room corners 6 3x3 floor 6 3x2 floors 6 3x1 floors 6 2x2 floors 6 doorways 12 doors A total of 111 pieces', '135.00', NULL, 51, 3, 1, 2, NULL, NULL, NULL),
(95, '2" long wall', 'A set of two 2" long walls', '5.00', NULL, 730, 1, 1, 1, NULL, NULL, NULL),
(96, '1" long wall', 'A set of two 1" long walls', '3.00', NULL, 740, 1, 1, 2, NULL, NULL, NULL),
(97, 'Ruined Wall', 'A ruined dungeon wall', '4.00', NULL, 750, 1, 1, 1, NULL, NULL, NULL),
(0, 'test', 'a test item', '1.00', NULL, 1000, 3, NULL, 5, NULL, NULL, NULL),
(0, 'test', 'a test item', '1.00', NULL, 1000, 3, NULL, 5, NULL, NULL, NULL),
(0, 'test', 'a test item', '1.00', NULL, 1000, 3, NULL, 5, NULL, b'1', NULL);
--
-- Database: `itarswor_ks`
--
CREATE DATABASE `itarswor_ks` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `itarswor_ks`;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `description`, `sort`) VALUES
(1, 'Dungeon', 'Dungeon', 20),
(2, 'Accessories', 'Accessories', 30),
(3, 'Sets', 'Sets', 10);

-- --------------------------------------------------------

--
-- Table structure for table `colorpicker`
--

DROP TABLE IF EXISTS `colorpicker`;
CREATE TABLE IF NOT EXISTS `colorpicker` (
  `Hex` varchar(50) DEFAULT NULL,
  `Red` int(11) DEFAULT NULL,
  `Green` int(11) DEFAULT NULL,
  `Blue` int(11) DEFAULT NULL,
  `Sum` int(11) DEFAULT NULL,
  `Sample` varchar(50) DEFAULT NULL,
  `Group` varchar(50) DEFAULT NULL,
  `Coat` varchar(50) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colorpicker`
--

INSERT INTO `colorpicker` (`Hex`, `Red`, `Green`, `Blue`, `Sum`, `Sample`, `Group`, `Coat`, `Name`) VALUES
('0', 0, 0, 0, 0, NULL, 'Molten Lava', 'F', 'Cold Mineral'),
('C0122B', 192, 18, 43, 253, NULL, 'Fresh Blood', 'A', 'Coagulated'),
('D1132E', 209, 19, 46, 274, NULL, 'Molten Lava', 'D', 'Flowing Lava'),
('9C1325', 156, 19, 37, 212, NULL, 'Roses', 'A', 'Crimson Petal'),
('A11826', 161, 24, 38, 223, NULL, 'Roses', 'B', 'True Love'),
('492562', 73, 37, 98, 208, NULL, 'Purple Worm', 'A', 'Creeper'),
('36252E', 54, 37, 46, 137, NULL, 'Bruised Flesh', 'A', 'Contusion'),
('342528', 52, 37, 40, 129, NULL, 'Molten Lava', 'E', 'Burning Stone'),
('29282B', 41, 40, 43, 124, NULL, 'Cinder Soot', 'A', 'Charred Wood'),
('93332C', 147, 51, 44, 242, NULL, 'Fieldstone', 'O', 'Laterite Quarry'),
('CC373C', 204, 55, 60, 319, NULL, 'Red Dragon', 'B', 'Garnet'),
('963734', 150, 55, 52, 257, NULL, 'Red Brickwork', 'B', 'Terracotta'),
('5F372D', 95, 55, 45, 195, NULL, 'Red Brickwork', 'O', 'Baked Boston'),
('2F3A2E', 47, 58, 46, 151, NULL, 'Hunter', 'A', 'Stealth Panel'),
('563C39', 86, 60, 57, 203, NULL, 'Aged Wood', 'A', 'Oiled Hardwood'),
('5D3C39', 93, 60, 57, 210, NULL, 'Sack Cloth', 'A', 'Burlap'),
('DA4358', 218, 67, 88, 373, NULL, 'Fresh Blood', 'B', 'Hemoglobin'),
('66446C', 102, 68, 108, 278, NULL, 'Royal Silk', 'A', 'Robe'),
('B54556', 181, 69, 86, 336, NULL, 'Red Dragon', 'A', 'Bloodstone'),
('B54547', 181, 69, 71, 321, NULL, 'Fire', 'A', 'Heat'),
('A74753', 167, 71, 83, 321, NULL, 'Daemon Flesh', 'A', 'Infernal'),
('6B472B', 107, 71, 43, 221, NULL, 'Slimy Swamp', 'A', 'Rotting Wood'),
('6F487D', 111, 72, 125, 308, NULL, 'Purple Worm', 'B', 'Crawler'),
('D34A2E', 211, 74, 46, 331, NULL, 'Ginger Hair', 'A', 'Felicia'),
('4B4B4F', 75, 75, 79, 229, NULL, 'Cinder Soot', 'B', 'Cold Ashes'),
('C84B3D', 200, 75, 61, 336, NULL, 'Rusted Iron', 'B', 'Hard Water'),
('204D99', 32, 77, 153, 262, NULL, 'Blue Gem', 'A', 'Sapphire'),
('474D42', 71, 77, 66, 214, NULL, 'Cavern Stone', 'A', 'Old Algae'),
('4A4E53', 74, 78, 83, 235, NULL, 'Alpha Wolf', 'A', 'Rufus'),
('DB516F', 219, 81, 111, 411, NULL, 'Bruised Flesh', 'C', 'Hemorrhage'),
('535456', 83, 84, 86, 253, NULL, 'Black Bear', 'A', 'Raven Feather'),
('5C5648', 92, 86, 72, 250, NULL, 'Troll Flesh', 'A', 'Cave'),
('4B5893', 75, 88, 147, 310, NULL, 'Pacific Ocean', 'A', 'Deep Sea'),
('465845', 70, 88, 69, 227, NULL, 'Deep Jungle', 'A', 'Vine'),
('E15955', 225, 89, 85, 399, NULL, 'Daemon Flesh', 'B', 'Demonic'),
('095A4E', 9, 90, 78, 177, NULL, 'Atlantic Sea', 'A', 'Mermaid Scale'),
('DF5B79', 223, 91, 121, 435, NULL, 'Red Dragon', 'C', 'Spinel'),
('725B4D', 114, 91, 77, 282, NULL, 'Rich Earth', 'A', 'Dry Sod'),
('1C5CAC', 28, 92, 172, 292, NULL, 'Blue Dragon', 'B', 'Cobalt Core'),
('D65C99', 214, 92, 153, 459, NULL, 'Royal Silk', 'B', 'Purse'),
('505DA0', 80, 93, 160, 333, NULL, 'Bruised Flesh', 'B', 'Hickey'),
('4A5D80', 74, 93, 128, 295, NULL, 'Ubermarine', 'A', 'Dire Wolf'),
('6D5D4D', 109, 93, 77, 279, NULL, 'Grizzly', 'A', 'Alaskan'),
('3E6480', 62, 100, 128, 290, NULL, 'Blue Dragon', 'A', 'Adamantine'),
('83655D', 131, 101, 93, 325, NULL, 'Ogre Flesh', 'A', 'Grungy'),
('E7654C', 231, 101, 76, 408, NULL, 'Pumpkin', 'A', 'Pie'),
('8C654B', 140, 101, 75, 316, NULL, 'Tanned Leather', 'A', 'Buffalo'),
('A4654B', 164, 101, 75, 340, NULL, 'New Lumber', 'A', 'Walnut'),
('656A73', 101, 106, 115, 322, NULL, 'Gothic Stone', 'A', 'Chipped Shale'),
('826A45', 130, 106, 69, 305, NULL, 'Slimy Swamp', 'B', 'Churning Mud'),
('9B6B4D', 155, 107, 77, 339, NULL, 'Human Flesh', 'A', 'Southern Bronze'),
('106CBE', 16, 108, 190, 314, NULL, 'Ubermarine', 'B', 'Celestial'),
('A86D56', 168, 109, 86, 363, NULL, 'Aged Wood', 'B', 'Worn Timber'),
('936F9D', 147, 111, 157, 415, NULL, 'Violets', 'A', 'Posies'),
('DE70A8', 222, 112, 168, 502, NULL, 'Violets', 'B', 'Hibiscus'),
('D47041', 212, 112, 65, 389, NULL, 'Ginger Hair', 'B', 'Christina'),
('6E7176', 110, 113, 118, 341, NULL, 'Black Bear', 'B', 'Fluffy Ferret'),
('207356', 32, 115, 86, 233, NULL, 'Evergreen', 'A', 'Spruce'),
('75744C', 117, 116, 76, 309, NULL, 'Troll Flesh', 'B', 'Forest'),
('0F75B1', 15, 117, 177, 309, NULL, 'Arctic Glacier', 'A', 'Frozen Ocean'),
('D7768D', 215, 118, 141, 474, NULL, 'Intestine', 'A', 'Bowels'),
('B37664', 179, 118, 100, 397, NULL, 'Red Brickwork', 'C', 'Powdered Clay'),
('B1773B', 177, 119, 59, 355, NULL, 'Lamp Oil', 'A', 'Whale'),
('90786A', 144, 120, 106, 370, NULL, 'Ogre Flesh', 'B', 'Greasy'),
('6D7856', 109, 120, 86, 315, NULL, 'Goblin Flesh', 'A', 'Gangrene'),
('A47847', 164, 120, 71, 355, NULL, 'Insect', 'A', 'Beetle Brown'),
('5B7AB0', 91, 122, 176, 389, NULL, 'Pacific Ocean', 'B', 'Tidal Wave'),
('A47B5A', 164, 123, 90, 377, NULL, 'Rich Earth', 'B', 'Packed Dirt'),
('EB7B41', 235, 123, 65, 423, NULL, 'Pumpkin', 'B', 'Jack-o''-lantern'),
('527D5E', 82, 125, 94, 301, NULL, 'Deep Jungle', 'B', 'Rain Forest'),
('99806E', 153, 128, 110, 391, NULL, 'Fieldstone', 'A', 'River Rock'),
('C7814A', 199, 129, 74, 402, NULL, 'Egyptian Stone', 'A', 'Old Sands'),
('BC8355', 188, 131, 85, 404, NULL, 'Tanned Leather', 'B', 'Cattle'),
('848484', 132, 132, 132, 396, NULL, 'Cinder Soot', 'C', 'Cremation'),
('878475', 135, 132, 117, 384, NULL, 'Lizard Man', 'A', 'Komodo'),
('3487D0', 52, 135, 208, 395, NULL, 'Blue Gem', 'B', 'Azurite'),
('82878B', 130, 135, 139, 404, NULL, 'Black Bear', 'C', 'Grey Mouse'),
('B2885D', 178, 136, 93, 407, NULL, 'Sack Cloth', 'B', 'Tweed'),
('D18958', 209, 137, 88, 434, NULL, 'Dwarf Flesh', 'A', 'Bronzed Skin'),
('488952', 72, 137, 82, 291, NULL, 'Lush Grass', 'A', 'Deep Field'),
('AB8AB0', 171, 138, 176, 485, NULL, 'Succubus Flesh', 'A', 'Demona'),
('D18B49', 209, 139, 73, 421, NULL, 'Sunflowers', 'A', 'Seed'),
('968D8F', 150, 141, 143, 434, NULL, 'Alpha Wolf', 'B', 'Lupus'),
('088EAA', 8, 142, 170, 320, NULL, 'Mountain Lake', 'A', 'Pure Liquid'),
('F28EA4', 242, 142, 164, 548, NULL, 'Roses', 'C', 'Valentine'),
('8.00E+86', 0, 142, 134, 276, NULL, 'Atlantic Sea', 'B', 'Lost Sea'),
('AA8FB1', 170, 143, 177, 490, NULL, 'Purple Worm', 'C', 'Creature'),
('B58F83', 181, 143, 131, 455, NULL, 'Elf Flesh', 'A', 'Sun Tribe'),
('EF8F02', 239, 143, 2, 384, NULL, 'Molten Lava', 'C', 'Liquid Magma'),
('9B9090', 155, 144, 144, 443, NULL, 'Sandstone', 'A', 'Solid Silt'),
('C5905D', 197, 144, 93, 434, NULL, 'Cavern Stone', 'B', 'Ancient Dust'),
('F09125', 240, 145, 37, 422, NULL, 'Fire', 'B', 'Fuel'),
('8A937C', 138, 147, 124, 409, NULL, 'Forest Moss', 'A', 'North'),
('F194AE', 241, 148, 174, 563, NULL, 'Intestine', 'B', 'Ulcer'),
('C6964E', 198, 150, 78, 426, NULL, 'Grizzly', 'B', 'Californian'),
('CB9647', 203, 150, 71, 424, NULL, 'Lamp Oil', 'B', 'Kerosene'),
('949CA1', 148, 156, 161, 465, NULL, 'Gothic Stone', 'B', 'Carved Granite'),
('939C99', 147, 156, 153, 456, NULL, 'City Block', 'A', 'Downtown'),
('D19C7B', 209, 156, 123, 488, NULL, 'New Lumber', 'B', 'Almond'),
('EE9DC8', 238, 157, 200, 595, NULL, 'Succubus Flesh', 'B', 'Lilith'),
('B29D85', 178, 157, 133, 468, NULL, 'Rich Earth', 'C', 'Dusty Road'),
('6.99E+54', 105, 158, 82, 345, NULL, 'Goblin Flesh', 'B', 'Mucus'),
('8E9FB1', 142, 159, 177, 478, NULL, 'Well Water', 'A', 'Samara Slate'),
('B39F90', 179, 159, 144, 482, NULL, 'Sack Cloth', 'C', 'Linen'),
('9E9F7B', 158, 159, 123, 440, NULL, 'Slimy Swamp', 'C', 'Floating Scum'),
('429F4D', 66, 159, 77, 302, NULL, 'Evergreen', 'B', 'Pine'),
('F0A20D', 240, 162, 13, 415, NULL, 'Insect', 'B', 'Wasp Yellow'),
('88A3D0', 136, 163, 208, 507, NULL, 'Pacific Ocean', 'C', 'Shallow Shoal'),
('C9A39A', 201, 163, 154, 518, NULL, 'Zombie Flesh', 'A', 'Molting'),
('D6A87B', 214, 168, 123, 505, NULL, 'Bone', 'A', 'Raw Marrow'),
('E2A86B', 226, 168, 107, 501, NULL, 'Egyptian Stone', 'B', 'Rolling Dunes'),
('F3ABC3', 243, 171, 195, 609, NULL, 'Fresh Blood', 'C', 'Anemic'),
('37ACC3', 55, 172, 195, 422, NULL, 'Mountain Lake', 'B', 'Aquatica'),
('DAAD61', 218, 173, 97, 488, NULL, 'Fieldstone', 'B', 'Brushed Fossil'),
('5DAE44', 93, 174, 68, 335, NULL, 'Lush Grass', 'B', 'Freshly Cut'),
('F6B0AA', 246, 176, 170, 592, NULL, 'Daemon Flesh', 'C', 'Imp'),
('9BB198', 155, 177, 152, 484, NULL, 'Deep Jungle', 'C', 'Terrarium'),
('BCB278', 188, 178, 120, 486, NULL, 'Wheat', 'A', 'Chafe'),
('41B443', 65, 180, 67, 312, NULL, 'Leafy Green', 'A', 'Aspen'),
('02B5AF', 2, 181, 175, 358, NULL, 'Weathered Copper', 'A', 'Dragonfly'),
('E8B574', 232, 181, 116, 529, NULL, 'Blonde', 'A', 'Dunst'),
('F4B6D6', 244, 182, 214, 640, NULL, 'Royal Silk', 'C', 'Scarf'),
('CCB68D', 204, 182, 141, 527, NULL, 'Aged Wood', 'C', 'Burnished Plank'),
('E2B67D', 226, 182, 125, 533, NULL, 'Wheat', 'B', 'Toasted'),
('F5B668', 245, 182, 104, 531, NULL, 'Rusted Iron', 'C', 'Iron Oxide'),
('F7B948', 247, 185, 72, 504, NULL, 'Golden Sands', 'A', 'Golden Coast'),
('F5BA1C', 245, 186, 28, 459, NULL, 'Sunflowers', 'B', 'Petal'),
('47BC73', 71, 188, 115, 374, NULL, 'Forest Moss', 'B', 'Northwest'),
('68C0CF', 104, 192, 207, 503, NULL, 'Mountain Lake', 'C', 'Liquid Crystal'),
('E0C090', 224, 192, 144, 560, NULL, 'Tanned Leather', 'C', 'Deer'),
('F9C018', 249, 192, 24, 465, NULL, 'Molten Lava', 'B', 'Molten Core'),
('8FC1E8', 143, 193, 232, 568, NULL, 'Ubermarine', 'C', 'Clear Sky'),
('B8C1C7', 184, 193, 199, 576, NULL, 'Well Water', 'B', 'Ghastly Grey'),
('D9C1BD', 217, 193, 189, 599, NULL, 'Elf Flesh', 'B', 'Forest Folk'),
('7DC1AC', 125, 193, 172, 490, NULL, 'Sea Foam', 'A', 'Surge'),
('DCC18C', 220, 193, 140, 553, NULL, 'Grizzly', 'C', 'Maine'),
('51C16A', 81, 193, 106, 380, NULL, 'Lizard Man', 'B', 'Iguana'),
('B5C28E', 181, 194, 142, 517, NULL, 'Troll Flesh', 'C', 'Mountain'),
('A7C5E6', 167, 197, 230, 594, NULL, 'Blue Dragon', 'C', 'Moolooite'),
('C6C7C7', 198, 199, 199, 596, NULL, 'City Block', 'B', 'Back Alley'),
('E8C781', 232, 199, 129, 560, NULL, 'Blonde', 'B', 'Applegate'),
('F5C77D', 245, 199, 125, 569, NULL, 'Golden Sands', 'B', 'Seaside Sand'),
('CFC8C5', 207, 200, 197, 604, NULL, 'Alpha Wolf', 'C', 'Arctos'),
('F8CA75', 248, 202, 117, 567, NULL, 'Pumpkin', 'C', 'Squash'),
('4FCDC8', 79, 205, 200, 484, NULL, 'Sea Foam', 'B', 'Tidal'),
('F7CDA9', 247, 205, 169, 621, NULL, 'Ginger Hair', 'C', 'Faye'),
('AECEE7', 174, 206, 231, 611, NULL, 'Blue Gem', 'C', 'Topaz'),
('F6CEE2', 246, 206, 226, 678, NULL, 'Violets', 'C', 'Peonies'),
('CCCECE', 204, 206, 206, 616, NULL, 'Red Brickwork', 'A', 'Cement Mortar'),
('F8CEA3', 248, 206, 163, 617, NULL, 'Dwarf Flesh', 'B', 'Calloused Hands'),
('55CFC9', 85, 207, 201, 493, NULL, 'Atlantic Sea', 'C', 'Shallow Pool'),
('F9D1C1', 249, 209, 193, 651, NULL, 'Dwarf Flesh', 'C', 'Fleshy Cheek'),
('B9D123', 185, 209, 35, 429, NULL, 'Leafy Green', 'B', 'Birch'),
('DED4B9', 222, 212, 185, 619, NULL, 'Tallow', 'A', 'Lard'),
('F7D5DE', 247, 213, 222, 682, NULL, 'Intestine', 'C', 'Polyp'),
('E9D5B1', 233, 213, 177, 623, NULL, 'Bone', 'B', 'Sun Bleached'),
('F2D6A5', 242, 214, 165, 621, NULL, 'Egyptian Stone', 'C', 'Powdered Empires'),
('D2D7D5', 210, 215, 213, 638, NULL, 'Gothic Stone', 'C', 'Powdered Pebble'),
('F8D7BA', 248, 215, 186, 649, NULL, 'Human Flesh', 'B', 'Western Peach'),
('E5D7B5', 229, 215, 181, 625, NULL, 'New Lumber', 'C', 'Cashew'),
('96D992', 150, 217, 146, 513, NULL, 'Hunter', 'B', 'Radar Blip'),
('F2D985', 242, 217, 133, 592, NULL, 'Lamp Oil', 'C', 'Paraffin'),
('D8DAD5', 216, 218, 213, 647, NULL, 'City Block', 'C', 'Sidewalk'),
('A4DBE1', 164, 219, 225, 608, NULL, 'Arctic Glacier', 'B', 'Solid Sky'),
('E3DBD4', 227, 219, 212, 658, NULL, 'Elf Flesh', 'C', 'Cavern Clan'),
('D3DBD2', 211, 219, 210, 640, NULL, 'Cavern Stone', 'C', 'Calcium Drip'),
('D5DCDC', 213, 220, 220, 653, NULL, 'Well Water', 'C', 'Pale Moon'),
('F0DC9F', 240, 220, 159, 619, NULL, 'Sandstone', 'B', 'Sea of Sand'),
('E0DF93', 224, 223, 147, 594, NULL, 'Forest Moss', 'C', 'West'),
('F8DF88', 248, 223, 136, 607, NULL, 'Fire', 'C', 'Ignition'),
('F7E0E8', 247, 224, 232, 703, NULL, 'Succubus Flesh', 'C', 'Veronica'),
('EFE0A5', 239, 224, 165, 628, NULL, 'Fieldstone', 'C', 'Dusty Plains'),
('F1E1CC', 241, 225, 204, 670, NULL, 'Ogre Flesh', 'C', 'Grimey'),
('E8E3C8', 232, 227, 200, 659, NULL, 'Zombie Flesh', 'B', 'Cadaver'),
('F7E390', 247, 227, 144, 618, NULL, 'Tallow', 'B', 'Fat'),
('A9E4BD', 169, 228, 189, 586, NULL, 'Weathered Copper', 'B', 'Cladding'),
('AAE499', 170, 228, 153, 551, NULL, 'Evergreen', 'C', 'Fir'),
('E0E5E3', 224, 229, 227, 680, NULL, 'Arctic Glacier', 'C', 'Old Snow'),
('F6E8E1', 246, 232, 225, 703, NULL, 'Human Flesh', 'C', 'Northern Fair'),
('EFE8CF', 239, 232, 207, 678, NULL, 'Bone', 'C', 'Brittle Shard'),
('EDE8C0', 237, 232, 192, 661, NULL, 'Wheat', 'C', 'Flaxen'),
('BDE9E3', 189, 233, 227, 649, NULL, 'Lizard Man', 'C', 'Skink'),
('D5E9DD', 213, 233, 221, 667, NULL, 'Hunter', 'C', 'TechnoMint'),
('F4E9D2', 244, 233, 210, 687, NULL, 'Sandstone', 'C', 'Desert Dust'),
('F7E9C3', 247, 233, 195, 675, NULL, 'Golden Sands', 'C', 'Bleached Beach'),
('CDEAAE', 205, 234, 174, 613, NULL, 'Lush Grass', 'C', 'Seeding'),
('C7ECA5', 199, 236, 165, 600, NULL, 'Goblin Flesh', 'C', 'Snot'),
('C9EDDC', 201, 237, 220, 658, NULL, 'Sea Foam', 'C', 'Crest'),
('F7ED93', 247, 237, 147, 631, NULL, 'Sunflowers', 'C', 'Fringe'),
('DFEFB1', 223, 239, 177, 639, NULL, 'Leafy Green', 'C', 'Elm'),
('E3F0D8', 227, 240, 216, 683, NULL, 'Zombie Flesh', 'C', 'Rotting'),
('F5F07F', 245, 240, 127, 612, NULL, 'Insect', 'C', 'Larva Eggshell'),
('F4F4B5', 244, 244, 181, 669, NULL, 'Tallow', 'C', 'Butter'),
('F4F6D2', 244, 246, 210, 700, NULL, 'Blonde', 'C', 'Paltrow'),
('FFFFFF', 255, 255, 255, 765, NULL, 'Molten Lava', 'A', 'Burning White');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `comment` text,
  `entered_dt` datetime DEFAULT NULL,
  `filename` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `postal_code` varchar(50) DEFAULT NULL,
  `address1` varchar(200) DEFAULT NULL,
  `address2` varchar(200) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `activate_code` varchar(20) DEFAULT NULL,
  `admin` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `country`, `postal_code`, `address1`, `address2`, `email`, `city`, `state`, `password`, `active`, `activate_code`, `admin`) VALUES
(1, 'Gordon Rhea', 'USA', '38133', '7053 Markim Dr.', '', 'itar@itarsworkshop.com', 'Memphis', 'TN', 'Ã¿nÃ\\Â¶ÃŸÃÃ¼rv#Ã¹[Â¼â€¡Ã', 0, 'wVZSNVPc', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `text` varchar(100) CHARACTER SET utf8 NOT NULL,
  `url` varchar(2048) CHARACTER SET utf8 DEFAULT NULL,
  `master_id` int(11) DEFAULT '0',
  `image` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `menu_name`, `text`, `url`, `master_id`, `image`, `role`, `sort`) VALUES
(22, 'admin', 'Pieces', 'pieces.cgi', 21, NULL, NULL, 10),
(21, 'admin', 'Production', NULL, 0, NULL, NULL, 40),
(11, 'admin', 'Home', 'home.cgi', 0, NULL, NULL, 10),
(20, 'admin', 'Projects', 'table_edit.cgi?tid=11', 0, NULL, NULL, 30);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `orders_products`
--

DROP TABLE IF EXISTS `orders_products`;
CREATE TABLE IF NOT EXISTS `orders_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pieces`
--

DROP TABLE IF EXISTS `pieces`;
CREATE TABLE IF NOT EXISTS `pieces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pledges`
--

DROP TABLE IF EXISTS `pledges`;
CREATE TABLE IF NOT EXISTS `pledges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `pledge_amt` decimal(10,2) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `shipping` varchar(20) DEFAULT NULL,
  `pledged_time` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
CREATE TABLE IF NOT EXISTS `product_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(200) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `caption` varchar(200) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `filename`, `product_id`, `caption`, `description`) VALUES
(1, 'basic set.JPG', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(5,2) DEFAULT NULL,
  `images` varchar(500) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `ha` int(11) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `model` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=98 ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `images`, `sort`, `category`, `ha`, `stock`, `model`) VALUES
(1, 'Basic Dungeon Set Unpainted BROWN', 'This is your basic dungeon set. The set comes unpainted and cast in brown resin. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '45.00', 'basic_dungeon_set.JPG', 10, 3, 1, 0, NULL),
(2, 'Basic Dungeon Set Painted BROWN', 'This is your basic dungeon set. The set comes Painted in a grey color scheme. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '90.00', 'basic_dungeon_set.JPG', 20, 3, 1, 0, NULL),
(3, 'Deluxe Dungeon Set Unpainted BROWN', 'This set is twice the size of the basic set and comes unpainted and cast in brown resin. Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '90.00', 'deluxe_dungeon_set.jpg', 30, 3, 1, 0, NULL),
(4, 'Deluxe Dungeon Set Painted BROWN', 'This set is twice the size of the basic set and comes painted in a brown color scheme. Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '175.00', 'deluxe_dungeon_set.jpg', 40, 3, NULL, 0, NULL),
(5, 'Intermediate Dungeon Set Unpainted BROWN', 'This set is three of our basic sets and comes cast in brown resin. Set Contains: 12 straight 3x2 hallway sections 6 straight 3x3 hallway sections 6 straight 3x1 hallway sections 6 L hallway sections 6 T hallway sections 3 four way hallway intersection 12 room walls 12 room corners 6 3x3 floor 6 3x2 floors 6 3x1 floors 6 2x2 floors 6 doorways 12 doors A total of 111 pieces', '135.00', NULL, 50, 3, 1, 0, NULL),
(6, 'Ultimate Dungeon Set Unpainted BROWN', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes unpainted and cast in brown resin  Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '180.00', 'ultimate_dungeon_set.jpg', 60, 3, 1, 0, NULL),
(7, 'Ultimate Dungeon Set Painted BROWN', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes painted in a brown color scheme  Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '340.00', 'ultimate_dungeon_set.jpg', 70, 3, 1, 0, NULL),
(8, 'Basic Accessory Set', 'The Basic Accessory set includes: Barrels and Crates, Wooden Chests, Grain Sacks, Urns, Fire Sources, Crystals, Open Coffins, Tombstones, and Sarcofagus sets.', '25.00', NULL, 80, 3, 1, 37, NULL),
(9, 'Door set', 'A set of 4 doors.  One of each type.  Add extra doors to your set.', '3.00', 'doors.JPG', 90, 3, 1, 10, NULL),
(10, 'Room Set', 'A set of extra walls and corners to make rooms.  4 walls and 4 corners.', '10.00', 'room_set.jpg', 100, 3, 1, 10, NULL),
(11, 'Floor Set', 'A set of extra floors to make that one really large room.', '5.00', 'floor_set.jpg', 110, 3, 1, 10, NULL),
(12, 'Hallway Set', 'A set of 9 hallway pieces.  Create some extra hallways for your dungeon.', '15.00', 'hallway_set.jpg', 120, 3, 1, 10, NULL),
(13, 'Barrels and Crates', '3 long crates, 3 square crates, 3 open crates with lid, 3 closed barrels, 3 open barrels, 3 small barrels.  A total of 18 pieces.', '7.00', 'barrels_crates.jpg', 130, 2, 1, 68, 'IWS-ACC-005'),
(14, 'Wooden Chests', 'A set of 6 wooden chests.', '2.00', 'wooden_chests.jpg', 140, 2, 1, 62, NULL),
(15, 'Grain Sacks', 'A set of 4 grain sacks, 2 open grain sacks, and a pile of grain sacks.  A total of 7 pieces.', '2.00', 'grain_sacks.jpg', 150, 2, 1, 41, NULL),
(16, 'Urns', 'A set of 6 urns', '3.00', 'urns.jpg', 160, 2, 1, 16, NULL),
(17, 'Fire Sources', 'A set of 2 firestands, a brazier, a campfire and a burned out campfire.', '3.00', 'fire_sources.jpg', 170, 2, 1, 48, NULL),
(18, 'Bookcase with Books', 'A bookcase with 10 books and 2 scrolls', '2.00', 'bookcase_books.jpg', 180, 2, NULL, 72, NULL),
(19, 'Bookcase with Bottles', 'A bookcase with 20 bottles', '2.00', 'bookcase_bottles.jpg', 190, 2, NULL, 55, NULL),
(20, 'Throne', 'A throne', '5.00', 'throne.jpg', 200, 2, NULL, 29, NULL),
(21, 'Lanterns', 'A set of 12 lamps and lanterns.  Each set contains 4 of each unique light source.', '2.00', 'lanterns.jpg', 210, 2, NULL, 20, NULL),
(22, 'Table and Chairs', 'A set of two tables and 8 chairs.', '5.00', 'table_chairs.jpg', 220, 2, NULL, 55, NULL),
(23, 'Crystal Formations', '4 Crystal formations', '3.00', 'crystals.JPG', 230, 2, 1, 21, NULL),
(24, 'Human Skulls', 'A set of 10 Human Skulls.  This item comes unpainted.', '3.00', NULL, 240, 2, NULL, 8, NULL),
(25, 'Orc Skulls', 'A set of 10 Orc Skulls.  This item comes unpainted.', '3.00', NULL, 250, 2, NULL, 2, NULL),
(26, 'Cyclops Skulls', 'A set of 10 Cyclops Skulls. This item comes unpainted.', '3.00', NULL, 260, 2, NULL, 1, NULL),
(27, 'Cow Skulls', 'A set of 10 Cow Skulls.  This item comes unpainted.', '3.00', NULL, 270, 2, NULL, 2, NULL),
(28, 'Round Shields', 'A set of 12 shields (3 of each)', '5.00', 'shields.jpg', 280, 2, NULL, 5, NULL),
(29, 'Open Coffins', 'A set of two open coffins with lids.', '2.00', 'coffins.JPG', 290, 2, 1, 69, NULL),
(30, 'Tombstones', 'A set of 15 tombstones.', '2.00', 'tombstones.jpg', 300, 2, 1, 26, NULL),
(31, 'Egyptian Sarcophagus Set', 'An Egyptian Sarcophagus Set containing sarcophagus, lid, and mummy.', '2.00', 'sarcophagus.jpg', 310, 2, 1, 20, NULL),
(32, 'Sphinx with base', 'A sphinx statue with base.', '3.00', 'sphinx.jpg', 320, 2, 1, 6, NULL),
(33, 'International Shipping', NULL, '20.00', NULL, 1000, 3, NULL, 39, NULL),
(35, 'Doorway tile and doors', 'A doorway tile with one of each of unique doors (5 pieces total).', '6.00', NULL, 85, 1, 1, 6, NULL),
(36, 'Stair Set', 'A set of 2 straight stairs.  These stairs will fit inside the standard 2" hallway or work great in a room.', '4.00', NULL, 93, 1, 1, 94, NULL),
(37, 'Curved Stairs', 'A set of 2 circular stairway pieces.  Great for adding that circular staircase.', '4.00', NULL, 97, 1, 1, 72, NULL),
(38, 'Treasure Sacks', 'A set of 8 sacks.', '2.00', NULL, 330, 2, 0, 33, NULL),
(39, 'War Chests', 'A set of 2 locked treasure chests.  These treasure sacks are 1.25" wide by  0.6" deep by 0.7" tall.', '3.00', NULL, 340, 2, NULL, 65, NULL),
(40, 'Collapsed tunnel section', 'A cavein piece that fits perfectly inside the standard 2" hallway piece.', '4.00', NULL, 87, 1, 1, 4, NULL),
(41, 'Mixed Skull Set', 'A mixed set of skulls.  Each set contains 3 of each skull for a total of 12 skulls.', '4.00', NULL, 275, 2, NULL, 13, NULL),
(42, 'Torture Equipment', 'A set of 4 pieces fit for any torture chamber.  A spikey chair, a pillory, manacles on a pole, and an iron maiden.', '7.00', NULL, 350, 2, NULL, 44, NULL),
(43, 'Altar, basin and benches', 'Set contains: An altar, a stone basin, 6 gothic benches, 2 low gothic walls.', '10.00', NULL, 360, 2, NULL, 61, NULL),
(44, 'Altar and basin', 'ust the Altar and Basin.  This item comes unpainted.', '5.00', NULL, 370, 2, NULL, 7, NULL),
(45, 'Mixed Statue Set', 'A set of three statues.  One each of woman, totem, and cherub on a plineth.  This item coms unpainted.', '7.00', NULL, 380, 2, NULL, 26, NULL),
(46, 'Woman Statues', 'A set of three statues of a woman.  This item comes unpainted.', '7.00', NULL, 390, 2, NULL, 5, NULL),
(47, 'Totem Statues', 'A set of three statues of a totem.  This item comes unpainted.', '7.00', NULL, 400, 2, NULL, 3, NULL),
(48, 'Cherub Statues', 'A set of three statues of a cherub on a plineth.  This item comes unpainted.', '7.00', NULL, 410, 2, NULL, 2, NULL),
(49, 'Gargoyle', 'A set of six gargoyles.  This item comes unpainted.', '3.00', NULL, 420, 2, NULL, 27, NULL),
(50, 'Well', 'A single well that is 1.5" in diameter.  The campfire from the fire sources add on fits inside the well perfectly so combine this with the fire sources accessory (sold separately) and use it as a fire pit.  This item comes unpainted.', '2.00', NULL, 430, 2, NULL, 108, NULL),
(51, '45 degree wall', 'two 45 degree walls will be added to basic set (4 added to deluxe, 8 added to ultimate).', '4.00', NULL, 89, 1, 1, 5, NULL),
(52, '45 degree hallway', 'A set of two 45 degree hallway corners will be added to the basic dungeon set.  Deluxe sets get 4 sets and the Ultimate set gets 8.', '6.00', NULL, 88, 1, 1, 13, NULL),
(53, 'Accessory Set #2', 'contains: bookcase with books bookcase with bottles Throne lanterns Mixed skull set Round Shields Treasure Sacks war chests', '25.00', NULL, 81, 3, NULL, 32, NULL),
(54, 'Two Wheel Cart', 'A two wheel cart.  The wheels are cast separately.', '3.00', NULL, 440, 2, NULL, 46, NULL),
(55, 'Wall with barred drain', 'two walls with barred drains will be added to the basic set (4 for deluxe, and 8 for the ultimate sets).', '4.00', NULL, 89, 1, NULL, 4, NULL),
(56, 'Bar set', 'A set of modular bar pieces.  The bar pieces are 3/4" tall and 3/4" wide.  Set Contains: 4 two inch long bar sections 2 one inch long short bar sections 2 corner pieces (1" square) A total of 12" of bar for your adventurers drinking pleasure.', '10.00', NULL, 450, 2, NULL, 14, NULL),
(57, 'Bedroom set', 'A Bed, Armoire, 2 drawer dresser, 1 drawer dresser, and side table.  This item comes unpainted.', '6.00', NULL, 460, 2, NULL, 96, NULL),
(58, 'Tall Stairway Left', 'A 2" tall stairway piece', '2.00', NULL, 470, 1, NULL, 87, NULL),
(60, 'Archway', 'An archway piece that is perfect for making a bridge, or a balcony in a room.  The piece is 2" wide x 1" deep x 2" tall.', '2.00', NULL, 480, 1, 1, 22, NULL),
(61, 'Miniature Stair Adapter', 'An adapter to make it easy to use miniatures on stairs.  This piece is 1" square x 3/4" thick.  It works on any of our stairway pieces. (2 pieces)', '2.00', NULL, 490, 1, 1, 69, NULL),
(62, 'Tavern Accessories', 'A set of tableware suitable for serving adventurers in a tavern.<br>Set Contains:<br>3 pitchers<br>3 tankards<br>3 Goblets<br>3 empty plates<br>3 plates with a roast chicken<br>Total of 15 pieces.<br>', '3.00', NULL, 500, 2, NULL, 10, NULL),
(63, 'Fieldstone Columns', 'A set of two fieldstone columns.  Each column is 0.85" across at the base and 0.6" across at the top and is 2.5" tall.', '3.00', NULL, 510, 1, 1, 128, NULL),
(64, 'Flutted Columns', 'A set of two fluted columns.  Each column is 0.9" square at the base, 0.6" diameter at the top and 3" tall.', '3.00', NULL, 520, 1, 1, 26, NULL),
(65, 'Smooth Columns', 'A set of four smooth columns.  Each column is 0.7" square at the base, 0.45" diameter at the top and 2.5" tall. ', '3.00', NULL, 530, 1, 1, 39, NULL),
(66, 'Egyptian Hieroglyphic Columns', 'A set of two hieroglyphic columns.  Each column is 0.7" in diameter and 3.8" tall.', '3.00', NULL, 540, 1, 1, 29, NULL),
(67, 'Egyptian Columns', 'A set of two Egyptian Columns.  Each column is 1" in diameter and 4" tall.', '3.00', NULL, 550, 1, 1, 19, NULL),
(68, 'Round table and stools', 'A set of two round tables and eight stools.<br>This item comes unpainted.', '5.00', NULL, 560, 2, NULL, 11, NULL),
(69, 'Tavern Set', 'Set Contains:<br>Bar Set<br>2x Tavern Accessories<br>table and chairs (2 tables, 8 chairs)<br>Round Table and stools (2 tables, 8 stools)<br>8 stools<br>Total of 64 pieces<br>This item comes unpainted.', '28.00', NULL, 570, 2, NULL, 52, NULL),
(70, 'Halberd and weapon rack', 'This set contains 4 halberds and a weapons rack.  The halberds are separate from the rack and can either be glued in place or used elsewhere in your dungeon.  Total of 5 pieces.  This item comes unpainted.', '5.00', NULL, 580, 2, NULL, 23, NULL),
(71, 'Shield set #2', 'A set of 12 shields (3 of each design). This item comes unpainted', '5.00', NULL, 590, 2, NULL, 17, NULL),
(72, 'Secret Doors', 'A set of two secret doors', '2.00', NULL, 491, 1, 1, 10, NULL),
(73, 'Secret Passage wall', 'A set of two secret passage wall pieces.', '4.00', NULL, 492, 1, 1, 8, NULL),
(74, 'Egyptian Firestands', 'A set of 2 firestands with a sandblasted texture. Dimensions: 5/8" x 5/8" x 2" tall. This piece comes unpainted.', '3.00', NULL, 600, 2, 1, 29, NULL),
(75, 'Egyptian small obelisk ', 'A set of 2 small Egyptian Obelisks.  Dimensions: 1/2" square base x 1 1/2" tall.  This piece comes unpainted', '2.00', NULL, 610, 2, 1, 26, NULL),
(76, 'Standing Stones', 'A set of 6 ceremonial standing stones.  This piece comes unpainted.', '4.00', NULL, 620, 2, NULL, 36, NULL),
(77, 'Armor Stand', 'A stand of armor.  Great for any dungeon armory.  This item comes unpainted.', '2.00', NULL, 630, 2, NULL, 45, NULL),
(78, 'Egyptian Ram Sphinx', 'An Egyptian Sphinx with a ram''s head.  This item comes unpainted.', '3.00', NULL, 640, 2, NULL, 9, NULL),
(79, 'Dragon Statues', 'A set of two dragon statues.  This item comes unpainted.', '7.00', NULL, 650, 2, NULL, 23, NULL),
(80, 'Oriental Lion Statue', 'An oriental lion statue.  Dimensions: 1" x 0.6" wide x 1" tall.  This item comes unpainted.', '3.00', NULL, 660, 2, NULL, 13, NULL),
(81, 'Egyptian Pharaoh Seated', 'A seated pharaoh statue.  Dimensions: 0.75" wide x 1.1" x 2" tall.  This item comes unpainted.', '4.00', NULL, 670, 2, NULL, 16, NULL),
(82, 'Egyptian Bird Statues', 'A set of two Egyptian Bird Statues representing Horus.  Dimensions: 0.5" wide x 1" deep x 1.6" tall. This item is unpainted.', '4.00', NULL, 680, 2, NULL, 8, NULL),
(83, 'Tall Stairway Right', 'Just like the other tall stairway but a mirror image so it can go on the right side of the arch.', '2.00', NULL, 475, 1, 1, 76, NULL),
(84, 'Totem 1', 'An aztec totem statue.  Dimensions: 1" wide x 0.6" deep x 1.6" tall. This item comes unpainted.', '4.00', NULL, 690, 2, NULL, 7, NULL),
(85, 'Totem 2', 'An Aztec totem statue.  Dimensions: 1" wide x 0.6" deep x 2" tall.  This item comes unpainted.', '4.00', NULL, 700, 2, NULL, 6, NULL),
(86, 'Aztec Statue', 'An Aztec statue.  Dimensions: 1" wide x 0.6" deep x 1.6" tall. This item comes unpainted.', '4.00', NULL, 710, 2, NULL, 4, NULL),
(87, 'Aztec Statue 2', 'An Aztec Statue: An Aztec statue.  Dimensions: 1" wide x 0.5" deep x 2.9" tall. This item comes unpainted.', '4.00', NULL, 720, 2, NULL, 4, NULL),
(94, 'Ultimate Dungeon Set Painted GREY', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes painted in a grey color scheme (your choice) Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '340.00', 'ultimate_dungeon_set.jpg', 71, 3, 1, 0, NULL),
(93, 'Ultimate Dungeon Set Unpainted GREY', 'This set is twice the size of our deluxe set (four times the size of the basic set) and comes unpainted and cast in grey resin (your choice) Set contains: 16 straight 3x2 hallway sections 8 straight 3x3 hallway sections 8 straight 3x1 hallway sections 8 L hallway sections 8 T hallway sections 4 four way hallway intersection 16 room walls 16 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 16 doors A total of 140 pieces', '180.00', 'ultimate_dungeon_set.jpg', 61, 3, 1, 37, NULL),
(91, 'Deluxe Dungeon Set Painted GREY', 'This set is twice the size of the basic set and comes painted in a grey color scheme (your choice). Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '175.00', 'deluxe_dungeon_set.jpg', 41, 3, 1, 0, NULL),
(90, 'Deluxe Dungeon Set Unpainted GREY', 'This set is twice the size of the basic set and comes unpainted and cast in grey resin (your choice). Set contains: 8 straight 3x2 hallway sections 4 straight 3x3 hallway sections 4 straight 3x1 hallway sections 4 L hallway sections 4 T hallway sections 2 four way hallway intersection 8 room walls 8 room corners 4 3x3 floor 4 3x2 floors 4 3x1 floors 4 2x2 floors 4 doorways 8 doors A total of 70 pieces', '90.00', 'deluxe_dungeon_set.jpg', 31, 3, 1, 44, NULL),
(89, 'Basic Dungeon Set Painted GREY', 'This is your basic dungeon set. The set comes Painted in a grey color scheme (your choice). Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '90.00', 'basic_dungeon_set.JPG', 21, 3, 1, 0, NULL),
(88, 'Basic Dungeon Set Unpainted GREY', 'This is your basic dungeon set. The set comes unpainted and cast in grey resin. Set contains: 4 straight 3x2 hallway sections 2 straight 3x3 hallway sections 2 straight 3x1 hallway sections 2 L hallway sections 2 T hallway sections 1 four way hallway intersection 4 room walls 4 room corners 2 3x3 floor 2 3x2 floors 2 3x1 floors 2 2x2 floors 2 doorways 4 doors A total of 35 pieces', '45.00', 'basic_dungeon_set.JPG', 11, 3, 1, 13, NULL),
(92, 'Intermediate Dungeon Set Unpainted GREY', 'This set is three of our basic sets and comes cast in grey resin (your choice). Set Contains: 12 straight 3x2 hallway sections 6 straight 3x3 hallway sections 6 straight 3x1 hallway sections 6 L hallway sections 6 T hallway sections 3 four way hallway intersection 12 room walls 12 room corners 6 3x3 floor 6 3x2 floors 6 3x1 floors 6 2x2 floors 6 doorways 12 doors A total of 111 pieces', '135.00', NULL, 51, 3, 1, 11, NULL),
(95, '2" long wall', 'A set of two 2" long walls', '5.00', NULL, 730, 1, 1, 1, NULL),
(96, '1" long wall', 'A set of two 1" long walls', '3.00', NULL, 740, 1, 1, 2, NULL),
(97, 'Ruined Wall', 'A ruined dungeon wall', '4.00', NULL, 750, 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
--
-- Database: `itarswor_oscommerce`
--
CREATE DATABASE `itarswor_oscommerce` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `itarswor_oscommerce`;
--
-- Database: `itarswor_production`
--
CREATE DATABASE `itarswor_production` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `itarswor_production`;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `uid` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `password` varbinary(200) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT 'Y',
  `deleted` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `name`, `uid`, `password`, `last_login`, `level`, `active`, `deleted`) VALUES
(1, 'test', 'test', '#L~àÛÊ/†<ÆS•A', '2015-07-16 21:05:50', 4, 'N', 'N');

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

DROP TABLE IF EXISTS `attachments`;
CREATE TABLE IF NOT EXISTS `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codeset` varchar(20) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `file` varchar(200) DEFAULT NULL,
  `deleted` varchar(2) DEFAULT 'N',
  `upload_dt` datetime DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `attachments`
--

INSERT INTO `attachments` (`id`, `codeset`, `reference_id`, `filename`, `file`, `deleted`, `upload_dt`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(11, 'pieces', 1, 'Home Depot 1-25-2015.pdf', 'files/pieces/Home_Depot_1-25-2015_2.pdf', 'N', '0000-00-00 00:00:00', 'itar', '2015-01-27 21:25:03', NULL, NULL),
(10, 'pieces', 1, 'Home Depot 1-25-2015.pdf', 'files/pieces/Home_Depot_1-25-2015.pdf', 'N', '0000-00-00 00:00:00', 'itar', '2015-01-27 20:40:52', NULL, NULL),
(9, 'pieces', 1, 'Orc2.jpg', 'files/pieces/Orc2.jpg', 'N', '0000-00-00 00:00:00', 'itar', '2015-01-24 22:41:26', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `casting_material`
--

DROP TABLE IF EXISTS `casting_material`;
CREATE TABLE IF NOT EXISTS `casting_material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `volume_measurement` varchar(20) DEFAULT NULL,
  `cost_by_vol` decimal(11,6) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `recyclable` char(1) DEFAULT NULL,
  `created_dt` date DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `expense_attachment`
--

DROP TABLE IF EXISTS `expense_attachment`;
CREATE TABLE IF NOT EXISTS `expense_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_id` int(11) NOT NULL,
  `filename` varchar(200) DEFAULT NULL,
  `file` varchar(200) DEFAULT NULL,
  `deleted` varchar(2) DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

--
-- Dumping data for table `expense_attachment`
--

INSERT INTO `expense_attachment` (`id`, `expense_id`, `filename`, `file`, `deleted`) VALUES
(22, 1, 'files/expenses/Home_Depot_1-25-2015.pdf', 'Home Depot 1-25-2015.pdf', 'N'),
(26, 4, 'files/expenses/INVOICE_109972_1.PDF', 'INVOICE_109972.PDF', 'N'),
(25, 3, 'files/expenses/INVOICE_109873_1.PDF', 'INVOICE_109873.PDF', 'N'),
(27, 5, 'files/expenses/INVOICE_110233.PDF', 'INVOICE_110233.PDF', 'N'),
(28, 8, 'files/expenses/INVOICE_110864.PDF', 'INVOICE_110864.PDF', 'N'),
(29, 7, 'files/expenses/INVOICE_110538.PDF', 'INVOICE_110538.PDF', 'N'),
(30, 9, 'files/expenses/INVOICE_111006.PDF', 'INVOICE_111006.PDF', 'N'),
(31, 10, 'files/expenses/INVOICE_111416.PDF', 'INVOICE_111416.PDF', 'N'),
(32, 11, 'files/expenses/INVOICE_111490.PDF', 'INVOICE_111490.PDF', 'N'),
(33, 12, 'files/expenses/INVOICE_111569.PDF', 'INVOICE_111569.PDF', 'N'),
(34, 13, 'files/expenses/Uline_Invoice_67479432.PDF', 'Uline_Invoice_67479432.PDF', 'N');

-- --------------------------------------------------------

--
-- Table structure for table `expense_category`
--

DROP TABLE IF EXISTS `expense_category`;
CREATE TABLE IF NOT EXISTS `expense_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `description` text CHARACTER SET utf8,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `expense_category`
--

INSERT INTO `expense_category` (`id`, `name`, `description`) VALUES
(1, 'Production Supplies', 'supplies for production like resin, filler, etc '),
(2, 'Mold Making', 'Items for making molds'),
(3, 'USPS Shipping', 'Shipping fees to US Postal Service'),
(4, 'PayPal monthly fee', 'Monthly fees paid to PayPal'),
(5, 'PayPal CC fees', 'Fees paid to PayPal to process credit card transactions'),
(6, 'Shipping Supplies', 'Boxes, packing tape, bubble wrap, etc.');

-- --------------------------------------------------------

--
-- Table structure for table `expense_tax_category`
--

DROP TABLE IF EXISTS `expense_tax_category`;
CREATE TABLE IF NOT EXISTS `expense_tax_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `description` text CHARACTER SET utf8,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `expense_tax_category`
--

INSERT INTO `expense_tax_category` (`id`, `name`, `description`) VALUES
(1, 'Equipment', NULL),
(2, 'Supplies', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
CREATE TABLE IF NOT EXISTS `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `expense_dt` date DEFAULT NULL,
  `company` varchar(200) DEFAULT NULL,
  `tax_category` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `project` int(11) DEFAULT NULL,
  `notes` int(11) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `name`, `description`, `expense_dt`, `company`, `tax_category`, `category`, `amount`, `project`, `notes`, `entered_dt`, `entered_uid`, `updated_dt`, `updated_uid`) VALUES
(1, 'Latex Gloves and plastic drop cloth', '1 box Latex gloves\r\n2 plastic drop cloth', '2015-01-25', 'Home Depot', 2, 1, '17.41', 0, NULL, '0000-00-00 00:00:00', '', '2015-01-30 21:46:19', 'itar'),
(3, 'Filler', 'Microsphere Filler for resin casting', '2015-01-07', 'Reynolds AM', 2, 1, '364.98', 0, NULL, '0000-00-00 00:00:00', '', '2015-01-30 21:46:30', 'itar'),
(4, 'Mold Release', 'Universial Mold Release 5 gallons', '2015-01-14', 'Reynolds AM', 2, 1, '204.02', 0, NULL, '0000-00-00 00:00:00', '', '2015-02-07 17:31:06', 'itar'),
(5, 'Black Colorant', 'So-Strong Black colorant 1 pint.', '2015-02-03', 'Reynolds AM', 2, 1, '93.73', 0, NULL, '0000-00-00 00:00:00', '', '2015-03-02 11:50:42', 'test'),
(6, 'another test', 'test expense', '2015-03-02', 'test 4', 2, 2, '10.00', 1, NULL, '0000-00-00 00:00:00', '', '2015-03-02 21:09:44', 'itar'),
(7, 'Filler', '2x Ure-fil 15', '2015-02-26', 'Reynolds AM', 2, 1, '120.66', 2, NULL, '0000-00-00 00:00:00', '', '2015-05-17 20:07:01', 'itar'),
(8, 'Resin and Filler', 'Smooth-cast 320 5 gal\r\nUre-fil 15 x2\r\nwhite colorant', '2015-03-20', 'Reynolds AM', 2, 1, '593.75', 2, NULL, '0000-00-00 00:00:00', '', '2015-05-17 20:06:30', 'itar'),
(9, 'Resin and Filler', '1x Smooth-cast 320 5 gallon\r\n2x Ure-fil 15', '2015-03-30', 'Reynolds AM', 2, 1, '355.04', 2, NULL, '2015-05-17 20:09:35', 'itar', NULL, NULL),
(10, 'Resin and Filler', '1x Smooth-cast 320 5 gallon\r\n2x Ure-fil 15 5 gal', '2015-04-29', 'Reynolds AM', 2, 1, '546.75', 2, NULL, '2015-05-17 20:11:12', 'itar', NULL, NULL),
(11, 'Filler', '2x Ure-Fil 15 5gal', '2015-05-04', 'Reynolds AM', 2, 1, '120.52', 2, NULL, '2015-05-17 20:13:00', 'itar', NULL, NULL),
(12, 'Resin and Filler', '1x Smooth-cast 320 5 gallon\r\n2x Ure-fil 15 5 gallon', '2015-05-11', 'Reynolds AM', 2, 1, '546.90', 2, NULL, '2015-05-17 20:14:29', 'itar', NULL, NULL),
(13, 'Uline boxes', '10x10x10 boxes', '2015-05-12', 'Uline', 2, 6, '31.25', 2, NULL, '0000-00-00 00:00:00', '', '2015-05-20 11:24:20', 'itar');

-- --------------------------------------------------------

--
-- Table structure for table `gbl_codes`
--

DROP TABLE IF EXISTS `gbl_codes`;
CREATE TABLE IF NOT EXISTS `gbl_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codeset` varchar(100) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `alttext` varchar(200) DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `text` varchar(100) CHARACTER SET utf8 NOT NULL,
  `url` varchar(2048) CHARACTER SET utf8 DEFAULT NULL,
  `master_id` int(11) DEFAULT '0',
  `image` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `menu_name`, `text`, `url`, `master_id`, `image`, `role`, `sort`) VALUES
(24, 'admin', 'Molds', NULL, 0, NULL, NULL, 50),
(22, 'admin', 'Pieces', 'pieces.cgi', 21, NULL, NULL, 10),
(21, 'admin', 'Production', NULL, 0, NULL, NULL, 40),
(11, 'admin', 'Home', 'home.cgi', 0, NULL, NULL, 10),
(12, 'admin', 'Expenses', 'expenses.cgi', 0, NULL, NULL, 20),
(13, 'admin', 'Expense Category', 'table_edit.cgi?tid=12', 12, NULL, NULL, NULL),
(14, 'admin', 'Expense Tax Category', 'table_edit.cgi?tid=13', 12, NULL, NULL, NULL),
(15, 'admin', 'Security', NULL, 0, NULL, 'add_users', 100),
(16, 'admin', 'Roles', 'table_edit.cgi?tid=14', 15, NULL, 'add_users', 20),
(18, 'admin', 'Role Members', 'roles.cgi', 15, NULL, NULL, 30),
(19, 'admin', 'Users', 'add_user.cgi', 15, NULL, 'add_users', 10),
(20, 'admin', 'Projects', 'table_edit.cgi?tid=11', 0, NULL, NULL, 30),
(25, 'admin', 'Mold Types', 'table_edit.cgi?tid=17', 24, NULL, NULL, 20),
(26, 'admin', 'Mold Status', 'table_edit.cgi?tid=16', 24, NULL, NULL, 30),
(27, 'admin', 'Molds', 'molds.cgi', 24, NULL, NULL, 10),
(28, 'admin', 'Production Run', 'prod.cgi', 21, NULL, NULL, 20),
(29, 'admin', 'Logout', 'login.cgi?a=logout', 0, NULL, NULL, 999);

-- --------------------------------------------------------

--
-- Table structure for table `mold_status`
--

DROP TABLE IF EXISTS `mold_status`;
CREATE TABLE IF NOT EXISTS `mold_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `mold_status`
--

INSERT INTO `mold_status` (`id`, `name`, `description`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(1, 'In Use', 'Mold is currently in use', 'itar', '2015-01-25 20:19:02', NULL, NULL),
(2, 'Retired', 'Mold has been retired from production use but is still good.', 'itar', '2015-01-25 20:19:22', NULL, NULL),
(3, 'Worn Out', 'Mold has worn out and cannot provide usable casts', 'itar', '2015-01-25 20:19:47', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mold_type`
--

DROP TABLE IF EXISTS `mold_type`;
CREATE TABLE IF NOT EXISTS `mold_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `library_life` varchar(200) DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  `expected_casts` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `mold_type`
--

INSERT INTO `mold_type` (`id`, `name`, `description`, `library_life`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`, `expected_casts`) VALUES
(1, 'RTV', 'made from RTV', '5 years', 'itar', '2015-01-25 20:17:30', NULL, NULL, 100),
(2, 'Spin Cast', 'Molds for the spin caster.  Must be vulcanized', NULL, 'itar', '2015-01-25 20:21:13', NULL, NULL, 100);

-- --------------------------------------------------------

--
-- Table structure for table `molds`
--

DROP TABLE IF EXISTS `molds`;
CREATE TABLE IF NOT EXISTS `molds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `material` int(11) DEFAULT NULL,
  `piece_count` int(11) DEFAULT NULL,
  `notes` text,
  `status` int(11) DEFAULT NULL,
  `status_notes` text,
  `created_dt` date DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `molds`
--

INSERT INTO `molds` (`id`, `name`, `type`, `material`, `piece_count`, `notes`, `status`, `status_notes`, `created_dt`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(1, 'test mold', 2, NULL, NULL, NULL, 1, NULL, '2015-02-07', 'itar', '2015-02-07 18:30:25', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `molds_to_prod_run`
--

DROP TABLE IF EXISTS `molds_to_prod_run`;
CREATE TABLE IF NOT EXISTS `molds_to_prod_run` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `production_id` int(11) DEFAULT NULL,
  `mold_id` int(11) DEFAULT NULL,
  `casts` int(11) DEFAULT NULL,
  `material` int(11) DEFAULT NULL,
  `pieces_cast` int(11) DEFAULT NULL,
  `qc_pass` int(11) DEFAULT NULL,
  `qc_fail` int(11) DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pieces`
--

DROP TABLE IF EXISTS `pieces`;
CREATE TABLE IF NOT EXISTS `pieces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `notes` text,
  `volume` decimal(10,0) DEFAULT NULL,
  `units` varchar(20) DEFAULT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `pieces`
--

INSERT INTO `pieces` (`id`, `name`, `description`, `notes`, `volume`, `units`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(1, 'test', 'a test description', 'some notes', '10', 'ml', 'itar', '2015-01-22 20:52:07', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pieces_to_molds`
--

DROP TABLE IF EXISTS `pieces_to_molds`;
CREATE TABLE IF NOT EXISTS `pieces_to_molds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `piece_id` int(11) NOT NULL,
  `mold_id` int(11) NOT NULL,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `pieces_to_molds`
--

INSERT INTO `pieces_to_molds` (`id`, `piece_id`, `mold_id`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(2, 1, 1, 'itar', '2015-02-07 20:30:56', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `production_run`
--

DROP TABLE IF EXISTS `production_run`;
CREATE TABLE IF NOT EXISTS `production_run` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `production_dt` date DEFAULT NULL,
  `mold` int(11) DEFAULT NULL,
  `casts` int(11) DEFAULT NULL,
  `material` int(11) DEFAULT NULL,
  `pieces_cast` int(11) DEFAULT NULL,
  `qc_pass` int(11) DEFAULT NULL,
  `qc_fail` int(11) DEFAULT NULL,
  `notes` text,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `description` text CHARACTER SET utf8,
  `goal` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `start_dt` date DEFAULT NULL,
  `end_dt` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `name`, `description`, `goal`, `start_dt`, `end_dt`) VALUES
(1, 'test', NULL, NULL, '2015-03-02', '2015-03-31'),
(2, '2013 Dungeon KS', '2013 DUngeon KS ', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_members`
--

DROP TABLE IF EXISTS `role_members`;
CREATE TABLE IF NOT EXISTS `role_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(20) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `role_id` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT '1',
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `role_members`
--

INSERT INTO `role_members` (`id`, `uid`, `name`, `description`, `role_id`, `active`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(1, 'itar', NULL, NULL, 1, '1', '', '0000-00-00 00:00:00', 'itar', '2015-01-19 21:16:03'),
(2, 'Klingbeiliv', NULL, NULL, 1, '1', 'itar', '2015-01-19 21:25:10', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `entered_uid` varchar(20) DEFAULT NULL,
  `entered_dt` datetime DEFAULT NULL,
  `updated_uid` varchar(20) DEFAULT NULL,
  `updated_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `entered_uid`, `entered_dt`, `updated_uid`, `updated_dt`) VALUES
(1, 'add_users', 'modify the users', 'itar', '2015-01-16 19:13:12', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `table_edit`
--

DROP TABLE IF EXISTS `table_edit`;
CREATE TABLE IF NOT EXISTS `table_edit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `columns` varchar(250) CHARACTER SET utf8 DEFAULT '*',
  `edit` bit(1) DEFAULT b'1',
  `del` bit(1) DEFAULT b'0',
  `insert` bit(1) DEFAULT b'1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `table_edit`
--

INSERT INTO `table_edit` (`id`, `name`, `columns`, `edit`, `del`, `insert`) VALUES
(8, 'test_edit', '*', b'1', b'0', b'1'),
(9, 'menus', '*', b'1', b'1', b'1'),
(10, 'expenses', '*', b'1', b'1', b'1'),
(11, 'projects', '*', b'1', b'1', b'1'),
(12, 'expense_category', '*', b'1', b'1', b'1'),
(13, 'expense_tax_category', '*', b'1', b'1', b'1'),
(14, 'roles', '*', b'1', b'1', b'1'),
(15, 'role_members', '*', b'1', b'1', b'1'),
(16, 'mold_status', '*', b'1', b'1', b'1'),
(17, 'mold_type', '*', b'1', b'1', b'1');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
